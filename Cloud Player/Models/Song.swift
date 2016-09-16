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

class Song: Object {
    
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
    
    var state: ActionState = .NoAction
    
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
    
    // MARK: - Private methods
    
    private func removeExtensionFromName() {
        name = name.stringByReplacingOccurrencesOfString(".mp3", withString: "")
    }
}