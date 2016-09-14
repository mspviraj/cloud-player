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
    private let dropboxSongsSubject = PublishSubject<[Song]>()
    private let deviceSongsSubject = PublishSubject<[Song]>()
    private let disposeBag = DisposeBag()
    
    let songsObservable: Observable<[Song]>
    
    // MARK: - Lifecycle
    
    init() {
        songsObservable = Observable
            .combineLatest(deviceSongsSubject.asObservable(), dropboxSongsSubject.asObservable()) {
                // TODO: Need to create better filter for removing duplicates
                // Problem: Songs from device and Dropbox could be the same,
                // but properties could be different because song is stored on device
                return Array(Set($0 + $1)).sort({ (a, b) -> Bool in
                    a.name < b.name
                })
            }
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