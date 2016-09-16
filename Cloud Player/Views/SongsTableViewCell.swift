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
    @IBOutlet weak var albumLabel: UILabel!
    
    // MARK: - Properties
    
    var song: Song! {
        didSet {
            songLabel.text = song.name
            artistLabel.text = song.artist ?? "Unknown artist"
            albumLabel.text = song.album ?? "Unknown album"
            setAlbumImage()
        }
    }
    
    // MARK: - Methods
    
    private func setAlbumImage() {
        if let albumArt = song.albumArt {
            albumImageView.image = UIImage(data: albumArt)
        } else {
            // TODO: Add sample image
            albumImageView.image = UIImage()
        }
    }
}
