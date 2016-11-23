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
            albumArtImageView.image = UIImage(data: albumArtData as Data)
        }
    }
    
    private func initializeBindings() {
        playButton.rx.tap
            .debug("playButton.rx_tap")
            .map { self.song! }
            .bindTo(viewModel.songSubject)
            .addDisposableTo(disposeBag)
        
        previousButton.rx.tap
            .debug("previousButton.rx_tap")
            .map { -1 }
            .bindTo(viewModel.changeSongSubject)
            .addDisposableTo(disposeBag)
        
        nextButton.rx.tap
            .debug("nextButton.rx_tap")
            .map { 1 }
            .bindTo(viewModel.changeSongSubject)
            .addDisposableTo(disposeBag)
        
        favoriteButton.rx.tap
            .debug("favoriteButton.rx_tap")
            .map { self.song! }
            .bindTo(viewModel.favoriteSubject)
            .addDisposableTo(disposeBag)
        
        viewModel.songObservable
            .debug("song")
            .subscribe(onNext: { [weak self] (song) in
                if let _self = self {
                    _self.trackLabel.text = song.track!
                    _self.artistLabel.text = song.artist!
                    _self.albumLabel.text = song.album!
                    if let albumArtData = song.albumArt {
                        _self.albumArtImageView.image = UIImage(data: albumArtData as Data)
                    }
                }
            })
            .addDisposableTo(disposeBag)
        
        viewModel.playButtonObservable
            .debug("playButton")
            .subscribe(onNext: { [weak self] (isPlaying) in
                if let _self = self {
                    if isPlaying == true {
                        _self.playButton.setTitle("Pause", for: UIControlState.normal)
                    } else {
                        _self.playButton.setTitle("Play", for: UIControlState.normal)
                    }
                }
            })
            .addDisposableTo(disposeBag)
        
        viewModel.favoriteButtonObservable
            .debug("favoriteButton")
            .subscribe(onNext: { [weak self] (success) in
                if let _self = self {
                    if success == true {
                        _self.favoriteButton.title = "<33"
                    } else {
                        _self.favoriteButton.title = "<3"
                    }
                }
            })
            .addDisposableTo(disposeBag)
        
        viewModel.durationLabelObservable
            .debug("durationLabel")
            .bindTo(duration.rx.text)
            .addDisposableTo(disposeBag)
        
        viewModel.progressSliderObservable
            .debug("progressSlider")
            .bindTo(progressSlider.rx.value)
            .addDisposableTo(disposeBag)
    }
}
