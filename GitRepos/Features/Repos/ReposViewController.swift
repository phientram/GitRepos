//
//  ReposViewController.swift
//  GitRepos
//
//  Created by Phien Tram on 10/5/17.
//  Copyright © 2017 Phien Tram. All rights reserved.
//

import UIKit
import RxSwift

class ReposViewController: UIViewController, StoryboardInitializable {

    @IBOutlet private weak var tableView: UITableView!
    private let chooseLanguageButton = UIBarButtonItem(barButtonSystemItem: .organize, target: nil, action: nil)
    
    var viewModel: ReposViewModel!
    private let disposeBag = DisposeBag()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        setupBindings()
    }
    
    private func setupUI() {
        navigationItem.rightBarButtonItem = chooseLanguageButton
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    }
    
    private func setupBindings() {
        // choose language button
        chooseLanguageButton.rx.tap
            .bind(to: viewModel.chooseLanguage)
            .disposed(by: disposeBag)
        
        viewModel.repositories
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "RepositoryCell", cellType: RepositoryCell.self)) { [weak self] (_, repo, cell) in
                self?.setupRepositoryCell(cell, repository: repo)
            }
            .disposed(by: disposeBag)
        
        // title
        viewModel.title
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        // select row
        tableView.rx.modelSelected(RepositoryViewModel.self)
            .bind(to: viewModel.selectRepository)
            .disposed(by: disposeBag)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func setupRepositoryCell(_ cell: RepositoryCell, repository: RepositoryViewModel) {
        cell.selectionStyle = .none
        cell.setName(repository.name)
        cell.setDescription(repository.description)
        cell.setStarsCountTest(repository.starsCountText)
    }

}
