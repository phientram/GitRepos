//
//  LanguagesCoordinator.swift
//  GitRepos
//
//  Created by Phien Tram on 10/5/17.
//  Copyright © 2017 Phien Tram. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

/// Type that defines possible coordination results of the `LanguageListCoordinator`.
///
/// - language: Language was choosen.
/// - cancel: Cancel button was tapped.
enum LanguageCoordinationResult {
    case language(String)
    case cancel
}

class LanguageCoordinator: BaseCoordinator<LanguageCoordinationResult> {
    private let rootViewController: UIViewController
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    override func start() -> Observable<LanguageCoordinationResult> {
        let viewController = LanguagesViewController.initFromStoryboard(name: "Main")
        let navigationController = UINavigationController(rootViewController: viewController)
        let viewModel = LanguagesViewModel()
        viewController.viewModel = viewModel
        
        let cancel = viewModel.didCancel.map {_ in CoordinationResult.cancel }
        let language = viewModel.didSelectLanguage.map { CoordinationResult.language($0) }
        
        rootViewController.present(navigationController, animated: true)
        
        return Observable.merge(cancel, language)
            .take(1)
            .do(onNext: { [weak self] _ in self?.rootViewController.dismiss(animated: false) })
    }
}
