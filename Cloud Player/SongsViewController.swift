//
//  SongsViewController.swift
//  Cloud Player
//
//  Created by Nikola Majcen on 06/09/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit
import SwiftyDropbox
import AVFoundation

class SongsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var songsTableView: UITableView!
    
    // MARK: - Properties
    
    var client: DropboxClient?
    var audioPlayer: AVAudioPlayer?
    var songs = [Int:[String]]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        songsTableView.delegate = self
        songsTableView.dataSource = self
        
        if let client = Dropbox.authorizedClient {
            self.client = client
            fetchMetadata(client, query: ".mp3", page: 0, resultsPerPage: 10)
        }
    }
    
    // MARK: - Private functions
    
    // TODO: Create new class for Dropbox data management
    private func fetchMetadata(client: DropboxClient, query: String, page: UInt64, resultsPerPage: UInt64) {
        client.files
            .search(path: "", query: query, start: page, maxResults: resultsPerPage, mode: Files.SearchMode.Filename)
            .response({ (response, error) in
                if let result = response {
                    
                    var index = Int(page)
                    let _ = result.matches.map {
                        self.songs[index] = [$0.metadata.name, $0.metadata.pathLower!]
                        index = index + 1
                    }
                    
                    if result.more == true {
                        self.fetchMetadata(client, query: query, page: page + resultsPerPage, resultsPerPage: resultsPerPage)
                    } else {
                        self.reloadData()
                        return
                    }
                }
            })
    }
    
    private func playFile(client: DropboxClient, path: String) {
        client.files.download(path: path).response({ (response, error) in
            if let (metadata, data) = response {
                print("File: \(metadata.name)")
                
                do {
                    self.audioPlayer = try AVAudioPlayer(data: data)
                    self.audioPlayer!.prepareToPlay()
                    self.audioPlayer!.play()
                } catch {
                    print("Not working!")
                }
            }
        })
    }
    
    private func reloadData() {
        songsTableView.reloadData()
    }
}

// MARK: - Table View Extension

extension SongsViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - DataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SongsTableViewCell")
        cell?.textLabel?.text = songs[indexPath.row]?.first
        return cell!
    }
    
    // MARK: - Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if audioPlayer != nil && audioPlayer!.playing == true {
            audioPlayer!.stop()
        } else {
            playFile(self.client!, path: songs[indexPath.row]!.last!)
        }
    }
}