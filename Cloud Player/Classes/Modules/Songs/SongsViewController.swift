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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initializeData()
    }
    
    // MARK: - Private methods
    
    private func initializeBindings() {
        songsTableView.rx.setDelegate(self)
            .addDisposableTo(disposeBag)
        
        songsTableView.rx.modelSelected(Song.self)
            .map({ $0 })
            .subscribe(onNext: { [weak self] (song) in
                if let _self = self {
                    let indexPath = _self.songsTableView.indexPathForSelectedRow!
                    _self.songsTableView.deselectRow(at: indexPath, animated: true)
                    
                    let playerStoryboard = UIStoryboard(name: "Player", bundle: nil)
                    let playerViewController = playerStoryboard
                        .instantiateInitialViewController() as! PlayerViewController
                    playerViewController.song = song
                    _self.show(playerViewController, sender: nil)
                }
            })
            .addDisposableTo(disposeBag)
        
        viewModel.songsObservable
            .map({ $0 })
            .bindTo(songsTableView.rx.items(cellIdentifier: "SongsTableViewCell", cellType: SongsTableViewCell.self))
            { (row, element, cell) in
                cell.song = element
            }
            .addDisposableTo(disposeBag)
        
        viewModel.songsObservable
            .subscribe(onNext: { [weak self] (songs) in
                if let _self = self {
                    _self.hideSpinner()
                    if songs.isEmpty == true {
                        print("No songs. Need to sync!")
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

extension SongsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.none
    }
}
