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
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        showSpinner()
    }
    
    // MARK: - Private Methods
    
    private func initializeBindings() {
        syncButton.rx_tap
            .subscribeNext { [unowned self] (_) in
                self.showSpinner()
                self.viewModel.syncSongsFromDropbox()
            }
            .addDisposableTo(disposeBag)
        
        viewModel.songsObservable
            .bindTo(songsTableView.rx_itemsWithCellIdentifier("SongsTableViewCell")) { (row, element, cell) in
                cell.textLabel?.text = element.name
            }
            .addDisposableTo(disposeBag)
        
        viewModel.songsObservable
            .subscribeNext { [unowned self] (_) in
                self.hideSpinner()
            }
            .addDisposableTo(disposeBag)
    }
}