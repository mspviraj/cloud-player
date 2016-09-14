//
//  DropboxManager.swift
//  Cloud Player
//
//  Created by Nikola Majcen on 13/09/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import Foundation
import AVFoundation
import SwiftyDropbox

class DropboxManager {
    
    // MARK: - Properties
    
    private let client: DropboxClient!
    private let buffer: UInt64 = 1000
    
    // MARK: - Lifecycle
    
    init() {
        client = Dropbox.authorizedClient
    }
    
    // MARK: - Public methods
    
    func getSongs(completionHandler: ([Song]) -> ()) {
        client.files
            .search(path: "", query: ".mp3", start: 0, maxResults: buffer, mode: Files.SearchMode.Filename)
            .response { (response, error) in
                if let result = response {
                    let songs = result.matches
                        .map {
                            Song(name: $0.metadata.name, dropboxPath: $0.metadata.pathLower!)
                        }
                    completionHandler(songs)
                } else {
                    completionHandler([])
                }
        }
    }
    
    func getThumbnail(path: String, completionHandler: (data: NSData!) -> ()) {
        client.files
            .download(path: path)
            .response { (response, error) in
                if let (metadata, value) = response {
                    
                    let directory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first
                    let filename = NSURL(fileURLWithPath: directory!).URLByAppendingPathComponent(metadata.name)
                    
                    print(value.writeToURL(filename, atomically: true))
                    
                    let playerItem = AVPlayerItem(URL: filename)
                    let _ = playerItem.asset.commonMetadata.map {
                        if $0.commonKey == "artwork" {
                            if $0.dataValue != nil {
                                completionHandler(data: $0.dataValue)
                            }
                        }
                    }
                }
            }
    }
}