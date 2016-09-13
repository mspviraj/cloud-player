//
//  DropboxManager.swift
//  Cloud Player
//
//  Created by Nikola Majcen on 13/09/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import Foundation
import SwiftyDropbox

class DropboxManager {
    
    // MARK: - Properties
    
    private let client: DropboxClient!
    private let buffer: UInt64 = 1000
    
    // MARK: - Lifecycle
    
    init(client: DropboxClient) {
        self.client = client
    }
    
    // MARK: - Public methods
    
    func getSongs(completionHandler: ([Song]) -> ()) {
        client.files
            .search(path: "", query: ".mp3", start: 0, maxResults: buffer, mode: Files.SearchMode.Filename)
            .response { (response, error) in
                if let result = response {
                    let songs = result.matches
                        .map { Song(name: $0.metadata.name, path: $0.metadata.pathLower!) }
                    completionHandler(songs)
                } else {
                    completionHandler([])
                }
            }
    }
}