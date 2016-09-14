//
//  SongsTableViewCell.swift
//  Cloud Player
//
//  Created by Nikola Majcen on 13/09/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit

class SongsTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    // MARK: - Properties
    
    var song: Song! {
        didSet {
            songLabel.text = song.name
            artistLabel.text = song.dropboxPath
            // getThumbnail()
        }
    }
    
    // MARK: - Methods
    
    private func getThumbnail() {
        let dropboxManager = DropboxManager()
        dropboxManager.getThumbnail(song.dropboxPath) { (data) in
            if data != nil {
                self.albumImageView.image = UIImage(data: data)
            }
        }
    }
}
