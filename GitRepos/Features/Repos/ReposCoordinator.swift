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
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        return Observable.never()
    }
    
    private func showRepositoryDetail(url: URL, navigationController: UINavigationController) {
        navigationController.pushViewController(SFSafariViewController(url: url), animated: true)
    }
}
