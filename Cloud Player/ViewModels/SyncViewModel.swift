//
//  SyncViewModel.swift
//  Cloud Player
//
//  Created by Nikola Majcen on 14/09/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import Foundation
import RxSwift

class SyncViewModel {
    
    // MARK: - Properties
    
    private let dropboxManager = DropboxManager()
    private let databaseManager = DatabaseManager()
    private let fileManager = FileManager()
    
    private let dropboxSongsSubject = PublishSubject<[Song]>()
    private let deviceSongsSubject = PublishSubject<[Song]>()
    private let disposeBag = DisposeBag()
    
    let songSubject = PublishSubject<Song>()
    let syncSubject = PublishSubject<()>()
    let completionSubject = PublishSubject<Int>()
    
    let songsObservable: Observable<[Song]>
    let syncObservable: Observable<()>
    let completionObservable: Observable<Bool>
    
    // MARK: - Lifecycle
    
    init() {
        songsObservable = Observable
            .combineLatest(deviceSongsSubject.asObservable(), dropboxSongsSubject.asObservable()) {
                var allSongs = $0
                for dropboxSong in $1 {
                    var found = false
                    for song in allSongs {
                        if song.dropboxPath == dropboxSong.dropboxPath {
                            found = true
                            break
                        }
                    }
                    if found == false {
                        allSongs.append(dropboxSong)
                    }
                }
                return allSongs.sort(<)
            }
        
        syncObservable = syncSubject.asObservable()
            .map { $0 }
        
        completionObservable = completionSubject.asObservable()
            .map { $0 == 0 }
        
        songSubject.asObservable()
            .subscribeNext { [weak self] (song) in
                if let _self = self {
                    switch song.state {
                    case .NoAction:
                        if song.isOnDevice() == false {
                            song.changeActionState(.PendingToDownload)
                            _self.databaseManager.addSong(song)
                        } else {
                            song.changeActionState(.PendingToRemoval)
                            _self.databaseManager.updateSong(song)
                        }
                    default:
                        song.changeActionState(.NoAction)
                        _self.databaseManager.updateSong(song)
                    }
                }
            }
            .addDisposableTo(disposeBag)
        
        syncSubject.asObservable()
            .subscribeNext { [weak self] (_) in
                if let _self = self {
                    let songs = _self.databaseManager.getSongsPending()
                    _self.completionSubject.onNext(songs.count)
                    for song in songs {
                        switch song.state {
                        case .PendingToDownload:
                            song.downloadFromDropbox({ (success) in
                                if success == true {
                                    _self.completionSubject
                                        .onNext(_self.databaseManager.getSongsPending().count)
                                } else {
                                    // TODO: Implement onError
                                    _self.completionSubject.onNext(-1)
                                }
                            })
                        case .PendingToRemoval:
                            song.removeFromDevice({ (success) in
                                if success == true {
                                    _self.completionSubject
                                        .onNext(_self.databaseManager.getSongsPending().count)
                                } else {
                                    // TODO: Implement onError
                                    _self.completionSubject.onNext(-1)
                                }
                            })
                        case .NoAction:
                            continue
                        }
                    }
                }
            }
            .addDisposableTo(disposeBag)
        
        completionSubject.asObservable()
            .subscribeNext { [weak self] (_) in
                if let _self = self {
                    let songs = _self.databaseManager.getSongs()
                        .filter { $0.state == .NoAction && $0.isOnDevice() == false }
                    _self.databaseManager.removeSongs(songs)
                }
            }
            .addDisposableTo(disposeBag)
    }
    
    // MARK: - Public methods
    
    func getSongs() {
        getSongsFromDevice()
        getSongsFromDropbox()
    }
    
    // MARK: - Private methods
    
    private func getSongsFromDropbox() {
        dropboxManager.getSongs { (songs) in
            self.dropboxSongsSubject.onNext(songs)
        }
    }
    
    private func getSongsFromDevice() {
        deviceSongsSubject.onNext(databaseManager.getSongs())
    }
}