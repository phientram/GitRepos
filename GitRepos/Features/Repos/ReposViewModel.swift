//
//  ReposViewModel.swift
//  GitRepos
//
//  Created by Phien Tram on 10/5/17.
//  Copyright © 2017 Phien Tram. All rights reserved.
//

import Foundation
import RxSwift

class ReposViewModel {
    // MARK: - Inputs
    
    /// Call to update current language. Causes reload of the repositories.
    let setCurrentLanguage: AnyObserver<String>
    
    /// Call to open repository page.
    let selectRepository: AnyObserver<RepositoryViewModel>
    
    // MARK: - Outputs
    
    /// Emits an array of fetched repositories.
    let repositories: Observable<[RepositoryViewModel]>
    
    /// Emits an url of repository page to be shown.
    let showRepository: Observable<URL>
    
    /// Emits a formatted title for a navigation item.
    let title: Observable<String>
    
    init(initialLanguage: String, githubService: GithubService = GithubService()) {
        
        let _currentLanguageSubject = BehaviorSubject<String>(value: initialLanguage)
        self.setCurrentLanguage = _currentLanguageSubject.asObserver()
        
        self.title = _currentLanguageSubject.asObservable()
        
        self.repositories = _currentLanguageSubject.asObservable()
            .flatMapLatest { language in
                return githubService.getMostPopularRepositories(byLanguage: language)
                    .catchError { error in
                        // show error
                        return Observable.empty()
                    }
            }
            .map { repositories in repositories.map(RepositoryViewModel.init) }
        
        
        let _selectRepository = PublishSubject<RepositoryViewModel>()
        self.selectRepository = _selectRepository.asObserver()
        self.showRepository = _selectRepository.asObservable().map { $0.url }
    }
}
