//
//  LanguagesViewModel.swift
//  GitRepos
//
//  Created by Phien Tram on 10/5/17.
//  Copyright © 2017 Phien Tram. All rights reserved.
//

import Foundation
import RxSwift

class LanguagesViewModel {
    // MARK: - Inputs
    let selectLanguage: AnyObserver<String>
    let cancel: AnyObserver<Void>
    
    // MARK: - Outputs
    let languages: Observable<[String]>
    let didSelectLanguage: Observable<String>
    let didCancel: Observable<Void>
    
    init(githubService: GithubService = GithubService()) {
        self.languages = githubService.getLanguages()
        
        let _selectLanguageSubject = PublishSubject<String>()
        self.selectLanguage = _selectLanguageSubject.asObserver()
        self.didSelectLanguage = _selectLanguageSubject.asObservable()
        
        let _cancelSubject = PublishSubject<Void>()
        self.cancel = _cancelSubject.asObserver()
        self.didCancel = _cancelSubject.asObservable()
    }
}
