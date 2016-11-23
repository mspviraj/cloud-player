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
        client = DropboxClientsManager.authorizedClient
    }
    
    // MARK: - Public methods
    
    func getSongs(completionHandler: @escaping ([Song]) -> ()) {
        client.files
            .search(path: "", query: ".mp3", start: 0, maxResults: buffer, mode: Files.SearchMode.filename)
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
    
    func downloadSong(path: String, completionHandler: @escaping ((Song, Data)!) -> ()) {
        client.files
            .download(path: path)
            .response { (response, error) in
                if let (metadata, value) = response {
                    let song = Song(metadata: metadata)
                    completionHandler((song, value))
                } else {
                    completionHandler(nil)
                }
            }
    }
    
    func getThumbnail(path: String, completionHandler: @escaping (_ data: NSData?) -> ()) {
        client.files
            .download(path: path)
            .response { (response, error) in
                if let (metadata, value) = response {
                    
                    let directory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
                    let filename = NSURL(fileURLWithPath: directory!).appendingPathComponent(metadata.name)
                    
                    try! value.write(to: filename!, options: Data.WritingOptions.atomic)
                    
                    let playerItem = AVPlayerItem(url: filename!)
                    let _ = playerItem.asset.commonMetadata.map {
                        if $0.commonKey == "artwork" {
                            if $0.dataValue != nil {
                                completionHandler($0.dataValue as NSData?)
                            }
                        }
                    }
                }
            }
    }
}
