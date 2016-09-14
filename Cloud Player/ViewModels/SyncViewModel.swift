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
        
    }
    
    private func getSongsFromDropbox() {
        dropboxManager.getSongs { (songs) in
            self.songsSubject.onNext(songs)
        }
    }
    
    private func getSongsFromDevice() {
        
    }
}