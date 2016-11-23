//
//  SongsViewModel.swift
//  Cloud Player
//
//  Created by Nikola Majcen on 13/09/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import Foundation
import RxSwift

class SongsViewModel {
    
    // MARK: - Properties
    
    private let databaseManager = DatabaseManager()
    private let songManager = SongManager()
    private let songsSubject = PublishSubject<[Song]>()
    private let disposeBag = DisposeBag()
    
    let songsObservable: Observable<[Song]>
    
    // MARK: - Lifecycle
    
    init() {
        songsObservable = songsSubject.asObservable()
            .map { $0 }
    }
    
    // MARK: - Methods
    
    func getSongs() {
        let songs = databaseManager.getSongs()
            .filter {
                let fileExists = songManager.fileExists(song: $0)
                if fileExists == false {
                    _ = databaseManager.removeSong(song: $0)
                }
                return fileExists
            }
        songsSubject.onNext(songs)
    }
}
