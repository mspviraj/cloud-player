//
//  FavoritesViewController.swift
//  Cloud Player
//
//  Created by Nikola Majcen on 23/09/2016.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FavoritesViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var favoritesTableView: UITableView!
    
    // MARK: - Properties
    private let viewModel = FavoritesViewModel()
    private let disposeBag = DisposeBag()
    
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
        _ = favoritesTableView.rx.setDelegate(self)
        
        favoritesTableView.rx.modelSelected(Song.self)
            .subscribe(onNext: { [weak self] (song) in
                if let _self = self {
                    let indexPath = _self.favoritesTableView.indexPathForSelectedRow!
                    _self.favoritesTableView.deselectRow(at: indexPath, animated: true)
                    
                    let playerStoryboard = UIStoryboard(name: "Player", bundle: nil)
                    let playerViewController = playerStoryboard
                        .instantiateInitialViewController() as! PlayerViewController
                    playerViewController.song = song
                    _self.show(playerViewController, sender: nil)
                }
            })
            .addDisposableTo(disposeBag)
        
        viewModel.songsObservable
            .bindTo(favoritesTableView.rx.items(cellIdentifier: "FavoritesTableViewCell", cellType: SongsTableViewCell.self))
            { (row, element, cell) in
                cell.song = element
            }
            .addDisposableTo(disposeBag)
        
        viewModel.songsObservable
            .subscribe(onNext: { [weak self] (songs) in
                if let _self = self {
                    _self.hideSpinner()
                    if songs.isEmpty == true {
                        print("No favorite songs.")
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

extension FavoritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.none
    }
}
