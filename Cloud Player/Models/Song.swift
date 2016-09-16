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
    let duration: RealmOptional<Int> = RealmOptional<Int>()
    // TODO: Add albumArt
    
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
    
    // MARK: - Private methods
    
    private func removeExtensionFromName() {
        name = name.stringByReplacingOccurrencesOfString(".mp3", withString: "")
    }
}