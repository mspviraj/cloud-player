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
    private let syncSubject = PublishSubject<()>()
    private let disposeBag = DisposeBag()
    
    private var songs = [Song]()
    private var numberOfChanges = 0
    
    let songsObservable: Observable<[Song]>
    let syncObservable: Observable<()>
    
    // MARK: - Lifecycle
    
    init() {
        songsObservable = Observable
            .combineLatest(self.deviceSongsSubject.asObservable(), self.dropboxSongsSubject.asObservable()) {
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
                
                return allSongs.sort({ (a, b) -> Bool in
                    a.name < b.name
                })
            }
        
        syncObservable = syncSubject.asObservable()
            .map { $0 }
    }
    
    // MARK: - Public methods
    
    func addSongs(songs: [Song]) {
        if self.songs.isEmpty == false {
            self.songs.removeAll()
        }
        self.songs = songs
    }
    
    func getSongs() {
        getSongsFromDevice()
        getSongsFromDropbox()
    }
    
    func syncSongs() {
        songs = songs.filter { $0.state != .NoAction }
        numberOfChanges = 0
        for song in songs {
            switch song.state {
            case .NoAction:
                continue
            case .PendingToDownload:
                downloadSongFromDropbox(song)
            case .PendingToRemoval:
                removeSongFromDevice(song)
            }
        }
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
    
    private func downloadSongFromDropbox(song: Song) {
        dropboxManager.downloadSong(song.dropboxPath) { (response) in
            if let (song, data) = response {
                if let path = self.fileManager.saveFile(song.name, data: data) {
                    song.filePath = path
                    self.databaseManager.addSong(song)
                }
            }
            self.numberOfChanges += 1
            if self.songs.count == self.numberOfChanges {
                self.syncSubject.onNext(())
            }
        }
    }
    
    private func removeSongFromDevice(song: Song) {
        if fileManager.removeFile(song.filePath!) == true {
            databaseManager.removeSong(song)
        }
        self.numberOfChanges += 1
        if self.songs.count == self.numberOfChanges {
            self.syncSubject.onNext(())
        }
    }
}