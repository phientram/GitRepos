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
    
    // MARK: - Outputs
    
    /// Emits an array of fetched repositories.
    let repositories: Observable<[RepositoryViewModel]>
    
    init(initialLanguage: String, githubService: GithubService = GithubService()) {
        
        let _currentLanguageSubject = BehaviorSubject<String>(value: initialLanguage)
        self.setCurrentLanguage = _currentLanguageSubject.asObserver()
        
        self.repositories = _currentLanguageSubject.asObservable()
            .flatMapLatest { language in
                return githubService.getMostPopularRepositories(byLanguage: language)
                    .catchError { error in
                        // show error
                        return Observable.empty()
                    }
            }
            .map { repositories in repositories.map(RepositoryViewModel.init) }
        
        
    }
}
