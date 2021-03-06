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
    
    let songSubject = PublishSubject<Song>()
    let favoriteSubject = PublishSubject<Song>()
    let progressSubject = PublishSubject<Int>()
    let changeSongSubject = PublishSubject<Int>()
    
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
            .map { return PlayerManager.shared.isPlaying(song: $0) }
        
        songSubject.asObservable()
            .debug("songSubject")
            .skip(1)
            .subscribe(onNext: { (song) in
                if PlayerManager.shared.isInPlayerQueue(song: song) == false {
                    PlayerManager.shared.initializeSong(song: song)
                }
                if PlayerManager.shared.isPlaying(song: song) == false {
                    PlayerManager.shared.play()
                } else {
                    PlayerManager.shared.pause()
                }
            })
            .addDisposableTo(disposeBag)
        
        favoriteSubject.asObservable()
            .debug("favoriteSubject")
            .subscribe(onNext: { (song) in
                song.changeFavoriteStatus()
            })
            .addDisposableTo(disposeBag)
        
        progressSubject.asObservable()
            .debug("progressSubject")
            .subscribe(onNext: { (value) in
                // TODO: Implement to update progress bar value
                print(value)
            })
            .addDisposableTo(disposeBag)
        
        changeSongSubject.asObservable()
            .debug("changeSongSubject")
            .subscribe(onNext: { (value) in
                if value == -1 {
                    // TODO: Implement to change song to previous
                } else {
                    // TODO Implement to change song to next
                }
            })
            .addDisposableTo(disposeBag)
    }
}
