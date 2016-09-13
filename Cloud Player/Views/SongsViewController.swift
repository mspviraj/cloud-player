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
    
    // MARK: - Properties
    
    let viewModel = SongsViewModel()
    let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.songsObservable
            .bindTo(songsTableView.rx_itemsWithCellIdentifier("SongsTableViewCell")) { (row, element, cell) in
                cell.textLabel?.text = element.name
            }
            .addDisposableTo(disposeBag)
    }
}