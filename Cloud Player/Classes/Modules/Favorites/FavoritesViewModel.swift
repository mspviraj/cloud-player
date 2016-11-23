//
//  FavoritesViewModel.swift
//  Cloud Player
//
//  Created by Nikola Majcen on 23/09/2016.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import Foundation
import RxSwift

class FavoritesViewModel {
    
    // MARK: - Properties
    
    private let databaseManager = DatabaseManager()
    private let songsSubject = PublishSubject<[Song]>()
    private let disposeBag = DisposeBag()
    
    let songsObservable: Observable<[Song]>
    
    // MARK: - Lifecycle
    
    init() {
        songsObservable = songsSubject.asObservable()
            .map { $0 }
    }
    
    // MARK: - Public methods
    
    func getSongs() {
        let favoriteSongs = databaseManager.getSongs()
            .filter { $0.isFavorite() == true }
        songsSubject.onNext(favoriteSongs)
    }
}