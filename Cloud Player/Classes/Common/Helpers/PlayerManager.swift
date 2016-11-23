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
        audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: song.filePath!))
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
    
    func isPlaying(song: Song?) -> Bool {
        if let song = song, isInPlayerQueue(song: song) == true {
            return audioPlayer!.isPlaying
        }
        return false
    }
    
    func isInPlayerQueue(song: Song) -> Bool {
        if isPlayerQueueEmpty() == true {
            return false
        }
        if audioPlayer?.url! != URL(fileURLWithPath: song.filePath!) {
            return false
        }
        return true
    }
    
    // MARK: - Private methods
    
    private func isPlayerQueueEmpty() -> Bool {
        return audioPlayer == nil || audioPlayer!.url == nil
    }
}
