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
    
    let playButtonObservable: Observable<Bool>
    
    // MARK: - Lifecycle
    
    init() {
        
        playButtonObservable = songSubject.asObservable()
            .map { _ in
                return PlayerManager.shared.isPlaying()
            }
        
        songSubject.asObservable()
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