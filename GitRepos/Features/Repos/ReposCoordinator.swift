//
//  ReposCoordinator.swift
//  GitRepos
//
//  Created by Phien Tram on 10/5/17.
//  Copyright © 2017 Phien Tram. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import SafariServices

class ReposCoordinator: BaseCoordinator<Void> {
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        let viewModel = ReposViewModel(initialLanguage: "Swift")
        let viewController = ReposViewController.initFromStoryboard(name: "Main")
        let navigationController = UINavigationController(rootViewController: viewController)
        
        viewController.viewModel = viewModel
        
        // navigate to repository detail
        viewModel.showRepository
            .subscribe(onNext: { [weak self] url in
                self?.showRepositoryDetail(url: url, navigationController: navigationController)
            })
            .disposed(by: disposeBag)
        
        // navigate to language list
        viewModel.showLanguageList
            .flatMap { [weak self] _ -> Observable<String?> in
                guard let `self` = self else { return .empty() }
                return self.showLanguageList(on: viewController)
            }
            .filter { $0 != nil }
            .map { $0! }
            .bind(to: viewModel.setCurrentLanguage)
            .disposed(by: disposeBag)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        return Observable.never()
    }
    
    private func showRepositoryDetail(url: URL, navigationController: UINavigationController) {
        navigationController.pushViewController(SFSafariViewController(url: url), animated: true)
    }
    
    private func showLanguageList(on rootViewController: UIViewController) -> Observable<String?> {
        let languageListCoordinator = LanguageCoordinator(rootViewController: rootViewController)
        return coordinate(to: languageListCoordinator)
            .map { result in
                switch result {
                case .language(let language): return language
                case .cancel: return nil
                }
            }
    }
}
