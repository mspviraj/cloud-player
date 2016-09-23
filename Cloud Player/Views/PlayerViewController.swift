//
//  PlayerViewController.swift
//  Cloud Player
//
//  Created by Nikola Majcen on 21/09/2016.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PlayerViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
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
    
    private let viewModel = PlayerViewModel()
    private let disposeBag = DisposeBag()
    var song: Song?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
        initializeBindings()
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
    
    private func initializeBindings() {
        playButton.rx_tap
            .map { self.song! }
            .bindTo(viewModel.songSubject)
            .addDisposableTo(disposeBag)
        
        viewModel.playButtonObservable
            .subscribeNext { [weak self] (isPlaying) in
                if let _self = self {
                    if isPlaying == true {
                        _self.playButton.setTitle("Pause", forState: UIControlState.Normal)
                    } else {
                        _self.playButton.setTitle("Play", forState: UIControlState.Normal)
                    }
                }
            }
            .addDisposableTo(disposeBag)
    }
}