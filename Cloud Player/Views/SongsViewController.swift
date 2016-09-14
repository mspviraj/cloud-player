//
//  SongsViewController.swift
//  Cloud Player
//
//  Created by Nikola Majcen on 06/09/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SongsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var songsTableView: UITableView!
    @IBOutlet weak var syncButton: UIBarButtonItem!
    
    // MARK: - Properties
    
    let viewModel = SongsViewModel()
    let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeBindings()
        initializeData()
    }
    
    // MARK: - Private methods
    
    private func initializeBindings() {
        syncButton.rx_tap
            .subscribeNext { [unowned self] (_) in
                // TODO: Remove initializing data and add call for SyncViewController
                self.initializeData()
            }
            .addDisposableTo(disposeBag)
        
        viewModel.songsObservable
            .bindTo(songsTableView.rx_itemsWithCellIdentifier("SongsTableViewCell", cellType: SongsTableViewCell.self))
            { (row, element, cell) in
                cell.song = element
            }
            .addDisposableTo(disposeBag)
        
        viewModel.songsObservable
            .subscribeNext { [unowned self] (songs) in
                self.hideSpinner()
                if songs.isEmpty == true {
                    print("No songs. Need to sync!")
                }
            }
            .addDisposableTo(disposeBag)
    }
    
    private func initializeData() {
        showSpinner()
        viewModel.getSongs()
    }
}