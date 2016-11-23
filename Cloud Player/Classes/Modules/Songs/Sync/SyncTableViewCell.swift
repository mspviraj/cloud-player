//
//  SyncTableViewCell.swift
//  Cloud Player
//
//  Created by Nikola Majcen on 15/09/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit
import M13Checkbox

class SyncTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var checkbox: M13Checkbox!
    @IBOutlet weak var filenameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    // MARK: - Properties
    
    var song: Song! {
        didSet {
            filenameLabel.text = song.name
            setInitialStatus(animated: false)
        }
    }
    
    // MARK: - Public methods
    
    func changeState() {
        switch checkbox.checkState {
        case .checked:
            if song.isOnDevice() == true {
                checkbox.setCheckState(.mixed, animated: true)
                statusLabel.text = "Pending to remove from device"
            } else {
                setInitialStatus(animated: true)
            }
        case .unchecked:
            checkbox.setCheckState(.checked, animated: true)
            statusLabel.text = "Pending to download to device"
        case .mixed:
            setInitialStatus(animated: true)
        }
    }
    
    // MARK: - Private methods
    
    private func setInitialStatus(animated: Bool) {
        if song.isOnDevice() == true {
            checkbox.setCheckState(.checked, animated: animated)
            statusLabel.text = "Device storage"
        } else {
            checkbox.setCheckState(.unchecked, animated: animated)
            statusLabel.text = "Dropbox storage"
        }
    }
}
