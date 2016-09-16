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
    
    @IBOutlet weak var applyChangesButton: UIBarButtonItem!
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
        applyChangesButton.rx_tap
            .subscribeNext { [unowned self] (_) in
                self.showSpinner()
                self.viewModel.syncSongs()
            }
            .addDisposableTo(disposeBag)
        
        songsTableView.rx_itemSelected
            .subscribeNext({ [unowned self] (indexPath) in
                let cell = self.songsTableView.cellForRowAtIndexPath(indexPath) as! SyncTableViewCell
                cell.changeState()
            })
            .addDisposableTo(disposeBag)
        
        viewModel.songsObservable.asObservable()
            .bindTo(songsTableView.rx_itemsWithCellIdentifier("SyncTableViewCell", cellType: SyncTableViewCell.self))
            { (row, element, cell) in
                cell.song = element
            }
            .addDisposableTo(disposeBag)
        
        viewModel.songsObservable.asObservable()
            .subscribeNext { [unowned self] (songs) in
                self.hideSpinner()
                if songs.count == 0 {
                    print("No songs in Dropbox storage.")
                } else {
                    self.viewModel.addSongs(songs)
                }
            }
            .addDisposableTo(disposeBag)
        
        viewModel.syncObservable.asObservable()
            .subscribeNext { [unowned self] (_) in
                self.hideSpinner()
                self.navigationController?.popViewControllerAnimated(true)
            }
            .addDisposableTo(disposeBag)
    }
    
    private func initializeData() {
        showSpinner()
        viewModel.getSongs()
    }
}
