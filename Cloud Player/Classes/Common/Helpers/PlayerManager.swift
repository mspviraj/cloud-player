//
//  PlayerManager.swift
//  Cloud Player
//
//  Created by Nikola Majcen on 23/09/2016.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import Foundation
import AVFoundation

class PlayerManager {
    
    // MARK: - Properties
    
    static let shared = PlayerManager()
    
    private var audioPlayer: AVAudioPlayer?
    
    // MARK: - Public methods
    
    func initializeSong(song: Song) {
        audioPlayer = try! AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: song.filePath!) as URL)
    }
    
    func play() {
        audioPlayer!.prepareToPlay()
        audioPlayer!.play()
    }
    
    func pause() {
        audioPlayer!.pause()
    }
    
    func stop() {
        audioPlayer!.stop()
    }
    
    func previous() {
        
    }
    
    func next() {
        
    }
    
    func isSongInPlayer() -> Bool {
        return isEmpty() == false
    }
    
    func isSongInPlayer(song: Song) -> Bool {
        if audioPlayer?.url! == NSURL(fileURLWithPath: song.filePath!) as URL {
            return true
        }
        return false
    }
    
    func isPlaying() -> Bool {
        if isEmpty() == false {
            return audioPlayer!.isPlaying
        }
        return false
    }
    
    // MARK: - Private methods
    
    private func isEmpty() -> Bool {
        return audioPlayer == nil || audioPlayer!.url == nil
    }
}
