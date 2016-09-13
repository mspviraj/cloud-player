//
//  SongsViewModel.swift
//  Cloud Player
//
//  Created by Nikola Majcen on 13/09/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import Foundation
import SwiftyDropbox
import RxSwift

class SongsViewModel {
    
    // MARK: - Properties
    
    private let dropboxManager = DropboxManager(client: Dropbox.authorizedClient!)
    private let songsSubject = PublishSubject<[Song]>()
    private let disposeBag = DisposeBag()
    
    let songsObservable: Observable<[Song]>
    
    // MARK: - Lifecycle
    
    init() {
        songsObservable = songsSubject.asObservable()
            .map { $0 }
        
        // Temporary (in future songs info will be stored in database)
        syncSongsFromDropbox()
    }
    
    // MARK: - Methods
    
    func syncSongsFromDropbox() {
        dropboxManager.getSongs { (songs) in
            self.songsSubject.onNext(songs)
        }
    }
}