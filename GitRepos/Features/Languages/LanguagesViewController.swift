//
//  LanguagesViewController.swift
//  GitRepos
//
//  Created by Phien Tram on 10/5/17.
//  Copyright © 2017 Phien Tram. All rights reserved.
//

import UIKit
import RxSwift

class LanguagesViewController: UIViewController, StoryboardInitializable {
    
    var viewModel: LanguagesViewModel!
    let disposeBag = DisposeBag()
    
    @IBOutlet private weak var tableView: UITableView!
    private let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        setupBinding()
    }
    
    private func setupUI() {
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.title = "Choose a language"
        
        tableView.rowHeight = 48.0
    }
    
    private func setupBinding() {
        cancelButton.rx.tap
            .bind(to: viewModel.cancel)
            .disposed(by: disposeBag)
        
        
        viewModel.languages
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "LanguageCell", cellType: UITableViewCell.self)) { (_, language, cell) in
                cell.textLabel?.text = language
                cell.selectionStyle = .none
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(String.self)
            .bind(to: viewModel.selectLanguage)
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

}
