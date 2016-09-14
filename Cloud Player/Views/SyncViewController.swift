//
//  SyncViewController.swift
//  Cloud Player
//
//  Created by Nikola Majcen on 14/09/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SyncViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var songsTableView: UITableView!
    
    // MARK: - Properties
    
    let viewModel = SyncViewModel()
    let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeBindings()
        initializeData()
    }
    
    // MARK: - Private methods
    
    private func initializeBindings() {
        viewModel.songsObservable.asObservable()
            .bindTo(songsTableView.rx_itemsWithCellIdentifier("SyncTableViewCell")) { (row, element, cell) in
                cell.textLabel?.text = element.name
            }
            .addDisposableTo(disposeBag)
        
        viewModel.songsObservable.asObservable()
            .subscribeNext { [unowned self] (songs) in
                self.hideSpinner()
                if songs.count == 0 {
                    print("No songs in Dropbox storage.")
                }
            }
            .addDisposableTo(disposeBag)
    }
    
    private func initializeData() {
        showSpinner()
        viewModel.getSongs()
    }
}
