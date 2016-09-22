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
            .bindTo(viewModel.syncSubject)
            .addDisposableTo(disposeBag)
        
        songsTableView.rx_setDelegate(self)
        
        songsTableView.rx_itemSelected
            .subscribeNext { [weak self] (indexPath) in
                let cell = self?.songsTableView.cellForRowAtIndexPath(indexPath) as! SyncTableViewCell
                cell.changeState()
                let song = cell.song
                self?.viewModel.songSubject.onNext(song)
            }
            .addDisposableTo(disposeBag)
        
        viewModel.songsObservable
            .bindTo(songsTableView.rx_itemsWithCellIdentifier("SyncTableViewCell", cellType: SyncTableViewCell.self))
            { (row, element, cell) in
                cell.song = element
            }
            .addDisposableTo(disposeBag)
        
        viewModel.songsObservable
            .subscribeNext { [weak self] (songs) in
                self?.hideSpinner()
                if songs.count == 0 {
                    print("No songs in Dropbox storage.")
                }
            }
            .addDisposableTo(disposeBag)
        
        viewModel.syncObservable
            .subscribeNext { (_) in
                self.showSpinner()
            }
            .addDisposableTo(disposeBag)
        
        viewModel.completionObservable
            .subscribeNext { [weak self] (isCompleted) in
                if isCompleted == true {
                    self?.hideSpinner()
                    self?.navigationController?.popViewControllerAnimated(true)
                }
            }
            .addDisposableTo(disposeBag)
    }
    
    private func initializeData() {
        showSpinner()
        viewModel.getSongs()
    }
}

extension SyncViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.None
    }
}