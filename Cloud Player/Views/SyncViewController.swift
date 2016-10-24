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
        applyChangesButton.rx.tap
            .bindTo(viewModel.syncSubject)
            .addDisposableTo(disposeBag)
        
        _ = songsTableView.rx.setDelegate(self)
        
        songsTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] (indexPath) in
                if let _self = self {
                    let cell = _self.songsTableView.cellForRow(at: indexPath) as! SyncTableViewCell
                    cell.changeState()
                    let song = cell.song!
                    _self.viewModel.songSubject.onNext(song)
                }
            })
            .addDisposableTo(disposeBag)
        
        viewModel.songsObservable
            .bindTo(songsTableView.rx.items(cellIdentifier: "SyncTableViewCell", cellType: SyncTableViewCell.self))
            { (row, element, cell) in
                cell.song = element
            }
            .addDisposableTo(disposeBag)
        
        viewModel.songsObservable
            .subscribe(onNext: { [weak self] (songs) in
                if let _self = self {
                    _self.hideSpinner()
                    if songs.isEmpty == true {
                        print("No songs in Dropbox storage.")
                    }
                }
            })
            .addDisposableTo(disposeBag)
        
        viewModel.syncObservable
            .subscribe(onNext: { [weak self] (_) in
                if let _self = self {
                    _self.showSpinner()
                }
            })
            .addDisposableTo(disposeBag)
        
        viewModel.completionObservable
            .subscribe(onNext: { [weak self] (isCompleted) in
                if let _self = self {
                    if isCompleted == true {
                        _self.hideSpinner()
                        _ = _self.navigationController?.popViewController(animated: true)
                    }
                }
            })
            .addDisposableTo(disposeBag)
    }
    
    private func initializeData() {
        showSpinner()
        viewModel.getSongs()
    }
}

extension SyncViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.none
    }
}
