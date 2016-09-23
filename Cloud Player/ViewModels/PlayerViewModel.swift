//
//  PlayerViewModel.swift
//  Cloud Player
//
//  Created by Nikola Majcen on 23/09/2016.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import Foundation
import RxSwift

class PlayerViewModel {
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    let favoriteSubject = PublishSubject<Song>()
    let progressSubject = PublishSubject<Int>()
    let changeSongSubject = PublishSubject<Int>()
    let songSubject = PublishSubject<Song>()
    
    let songObservable: Observable<Song>
    let favoriteButtonObservable: Observable<Bool>
    let durationLabelObservable: Observable<String>
    let progressSliderObservable: Observable<Float>
    let previousButtonObservable: Observable<()>
    let nextButtonObservable: Observable<()>
    let playButtonObservable: Observable<Bool>
    
    // MARK: - Lifecycle
    
    init() {
        songObservable = songSubject.asObservable()
            .debug("songObservable")
            .map { $0 }
        
        favoriteButtonObservable = favoriteSubject.asObservable()
            .debug("favoriteButtonObservable")
            .map { $0.isFavorite() }
        
        durationLabelObservable = progressSubject.asObservable()
            .debug("durationLabelObservable")
            .map { time in
                return String(time)
            }
        
        progressSliderObservable = progressSubject.asObservable()
            .debug("progressSliderObservable")
            .map { time in
                return Float(time)
            }
        
        previousButtonObservable = changeSongSubject.asObservable()
            .debug("previousButtonObservable")
            .filter { $0 == -1 }
            .map { _ in return () }
        
        nextButtonObservable = changeSongSubject.asObservable()
            .debug("nextButtonObservable")
            .filter { $0 == 1 }
            .map { _ in return  () }
        
        playButtonObservable = songSubject.asObservable()
            .debug("playButtonObservable")
            .map { _ in
                return PlayerManager.shared.isPlaying()
        }
        
        favoriteSubject.asObservable()
            .debug("favoriteSubject")
            .subscribeNext { (song) in
                song.changeFavoriteStatus()
            }
            .addDisposableTo(disposeBag)
        
        progressSubject.asObservable()
            .debug("progressSubject")
            .subscribeNext { (value) in
                // TODO: Implement to update progress bar value
                print(value)
            }
            .addDisposableTo(disposeBag)
        
        changeSongSubject.asObservable()
            .debug("changeSongSubject")
            .subscribeNext { (value) in
                if value == -1 {
                    // TODO: Implement to change song to previous
                } else {
                    // TODO Implement to change song to next
                }
            }
            .addDisposableTo(disposeBag)
        
        songSubject.asObservable()
            .debug("songSubject")
            .subscribeNext { (song) in
                if PlayerManager.shared.isSongInPlayer() == false {
                    PlayerManager.shared.initializeSong(song)
                } else {
                    if PlayerManager.shared.isSongInPlayer(song) == false {
                        PlayerManager.shared.initializeSong(song)
                    }
                }
                if PlayerManager.shared.isPlaying() == false {
                    PlayerManager.shared.play()
                } else {
                    PlayerManager.shared.pause()
                }
            }
            .addDisposableTo(disposeBag)
    }
}