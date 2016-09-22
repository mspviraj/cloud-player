//
//  Song.swift
//  Cloud Player
//
//  Created by Nikola Majcen on 13/09/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyDropbox
import AVFoundation

class Song: Object, Comparable {
    
    // MARK: - Properties
    
    dynamic var id: String = NSUUID().UUIDString
    dynamic var name: String = ""
    dynamic var dropboxPath: String = ""
    dynamic var dropboxId: String? = nil

    dynamic var filePath: String? = nil
    let size: RealmOptional<Int> = RealmOptional<Int>()
    
    dynamic var track: String? = nil
    dynamic var artist: String? = nil
    dynamic var album: String? = nil
    dynamic var albumArt: NSData? = nil
    let duration: RealmOptional<Int> = RealmOptional<Int>()
    
    private dynamic var privateState: Int = ActionState.NoAction.rawValue
    var state: ActionState {
        get {
            return ActionState(rawValue: privateState)!
        }
        set {
            let realm = try! Realm()
            try! realm.write({ 
                privateState = newValue.rawValue
            })
        }
    }
    
    // MARK: - Lifecycle
    
    required convenience init(name: String, dropboxPath: String) {
        self.init()
        self.name = name
        removeExtensionFromName()
        self.dropboxPath = dropboxPath
    }
    
    required convenience init(metadata: Files.FileMetadata) {
        self.init()
        self.name = metadata.name
        removeExtensionFromName()
        self.dropboxPath = metadata.pathLower!
        self.dropboxId = metadata.id
        self.size.value = Int(metadata.size)
        self.track = metadata.name
        self.artist = "Unknown artist"
        self.album = "Unknown album"
    }
    
    // MARK: - Database rules
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // MARK: - Public methods
    
    func changeActionState(state: ActionState) {
        self.state = state
    }
    
    func isOnDevice() -> Bool {
        return filePath != nil
    }
    
    func updateMetadata() {
        let asset = AVAsset(URL: NSURL(fileURLWithPath: filePath!))
        for metadata in asset.commonMetadata {
            switch metadata.commonKey! {
            case "title":
                track = metadata.stringValue!
            case "artist":
                artist = metadata.stringValue!
            case "albumName":
                album = metadata.stringValue!
            case "artwork":
                albumArt = metadata.dataValue
            default:
                break
            }
        }
    }
    
    func downloadFromDropbox(completion: (success: Bool) -> ()) {
        let dropboxManager = DropboxManager()
        dropboxManager.downloadSong(dropboxPath) { (response) in
            if let (song, data) = response {
                let fileManager = FileManager()
                let databaseManager = DatabaseManager()
                if let path = fileManager.saveFile(song.name, data: data) {
                    song.id = self.id
                    song.filePath = path
                    song.changeActionState(.NoAction)
                    song.updateMetadata()
                    databaseManager.updateSong(song)
                    completion(success: true)
                    return
                }
            }
            completion(success: false)
        }
    }
    
    func removeFromDevice(completion: (success: Bool) -> ()) {
        let fileManager = FileManager()
        if fileManager.removeFile(filePath!) == true {
            let databaseManager = DatabaseManager()
            databaseManager.removeSong(self)
            completion(success: true)
            return
        }
        completion(success: false)
    }
    
    // MARK: - Private methods
    
    private func removeExtensionFromName() {
        name = name.stringByReplacingOccurrencesOfString(".mp3", withString: "")
    }
}

// MARK: - Comparable protocol methods
    
func == (lhs: Song, rhs: Song) -> Bool {
    return lhs.name == rhs.name
}

func < (lhs: Song, rhs: Song) -> Bool {
    return lhs.name < rhs.name
}