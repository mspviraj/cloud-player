//
//  Song.swift
//  Cloud Player
//
//  Created by Nikola Majcen on 13/09/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import Foundation
import RealmSwift

class Song: Object {
    
    // MARK: - Properties
    
    dynamic var id: String = NSUUID().UUIDString
    dynamic var name: String = ""
    dynamic var dropboxPath: String = ""
    
    dynamic var filePath: String? = nil
    let size: RealmOptional<Int> = RealmOptional<Int>()
    
    dynamic var track: String? = nil
    dynamic var artist: String? = nil
    let duration: RealmOptional<Int> = RealmOptional<Int>()
    // TODO: Add albumArt
    
    // MARK: - Lifecycle
    
    required convenience init(name: String, dropboxPath: String) {
        self.init()
        self.name = name
        self.dropboxPath = dropboxPath
    }
    
    // MARK: - Database rules
    
    override static func primaryKey() -> String? {
        return "id"
    }
}