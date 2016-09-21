//
//  PlayerViewController.swift
//  Cloud Player
//
//  Created by Nikola Majcen on 21/09/2016.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var albumArtImageView: UIImageView!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    // MARK: - Properties
    
    var song: Song?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
    }
    
    // MARK: - Private methods
    
    private func initializeUI() {
        trackLabel.text = song?.track!
        artistLabel.text = song?.artist!
        albumLabel.text = song?.album!
        if let albumArtData = song?.albumArt {
            albumArtImageView.image = UIImage(data: albumArtData)
        }
    }
}