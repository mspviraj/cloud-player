//
//  DatabaseManager.swift
//  Cloud Player
//
//  Created by Nikola Majcen on 14/09/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import Foundation
import RealmSwift

enum DatabaseResult {
    case Success
    case Failure
}

class DatabaseManager {
    
    // MARK: - Songs public methods
    
    func addSong(song: Song) -> DatabaseResult {
        if songAlreadyExists(song) == true { return .Failure }
        let realm = try! Realm()
        try! realm.write({ 
            realm.add(song)
        })
        return .Success
    }
    
    func updateSong(song: Song) -> DatabaseResult {
        if songAlreadyExists(song) == false { return .Failure }
        let realm = try! Realm()
        try! realm.write({
            realm.add(song, update: true)
        })
        return .Success
    }
    
    func removeSong(song: Song) -> DatabaseResult {
        if songAlreadyExists(song) == false { return .Failure }
        let realm = try! Realm()
        try! realm.write({ 
            realm.delete(song)
        })
        return .Success
    }
    
    func getSongs() -> [Song] {
        let realm = try! Realm()
        return Array(realm.objects(Song.self).sorted("name"))
    }
    
    func removeSongs(songs: [Song]) {
        let realm = try! Realm()
        try! realm.write({ 
            realm.delete(songs)
        })
    }
    
    func getSongsPending() -> [Song] {
        return getSongs().filter { $0.state != .NoAction }
    }
    
    // MARK: - Songs private methods
    
    private func songAlreadyExists(song: Song) -> Bool {
        let realm = try! Realm()
        if realm.objectForPrimaryKey(Song.self, key: song.id) != nil {
            return true
        }
        return false
    }
}