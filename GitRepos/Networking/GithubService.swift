//
//  GithubService.swift
//  GitRepos
//
//  Created by Phien Tram on 10/5/17.
//  Copyright © 2017 Phien Tram. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum ServiceError: Error {
    case cannotParse
}

class GithubService {
    private let session: URLSession!
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func getLanguages() -> Observable<[String]> {
        return Observable.just([
            "Swift",
            "Objective-C",
            "Java",
            "C",
            "C++",
            "Python",
            "C#",
            "Kotlin",
            "Javascript",
            "Typescript",
            "Golang",
            "Erlang"
            ])
    }
    
    /// - Parameter language: Language to filter by
    /// - Returns: A list of most popular repositories filtered by langugage
    func getMostPopularRepositories(byLanguage language: String) -> Observable<[Repository]> {
        let encodedLanguage = language.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let url = URL(string: "https://api.github.com/search/repositories?q=language:\(encodedLanguage)&sort=stars")!
        return session.rx
            .json(url: url)
            .flatMap { json throws -> Observable<[Repository]> in
                guard
                    let json = json as? [String: Any],
                let itemsJSON = json["items"] as? [[String: Any]]
                else { return Observable.error(ServiceError.cannotParse) }
                
                let repos = itemsJSON.flatMap(Repository.init)
                return Observable.just(repos)
            }
    }
}
