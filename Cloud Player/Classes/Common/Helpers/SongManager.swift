//
//  SongManager.swift
//  Cloud Player
//
//  Created by Nikola Majcen on 16/09/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import Foundation

class SongManager {
    
    // MARK: - Properties
    
    private let fileManager = FileManager.default
    private let directoryName = "iOSCloudPlayer"
    
    // MARK: - Public methods
    
    func saveFile(name: String, data: Data) -> String! {
        let rootDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                                    .userDomainMask, true).first! as NSString
        let directoryPath = rootDirectoryPath.appendingPathComponent(directoryName) as NSString
        if isDirectoryCreated(path: directoryPath as String) == false {
            createMainDirectory(path: directoryPath as String)
        }
        
        let path = directoryPath.appendingPathComponent(name + ".mp3")
        if fileManager.createFile(atPath: path, contents: data, attributes: nil) == true {
            return path
        } else {
            return nil
        }
    }
    
    func removeFile(path: String) -> Bool {
        if fileManager.fileExists(atPath: path) == false {
            return true
        }
        
        do {
            try fileManager.removeItem(atPath: path)
            return true
        } catch let error as NSError {
            print(error.description)
            return false
        }
    }
    
    func fileExists(song: Song) -> Bool {
        return song.isOnDevice() && fileManager.fileExists(atPath: song.filePath!)
    }
    
    // MARK: - Private methods
    
    private func createMainDirectory(path: String) {
        do {
            try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    private func isDirectoryCreated(path: String) -> Bool {
        var isDirectory : ObjCBool = false
        let fileExists = fileManager.fileExists(atPath: path, isDirectory: &isDirectory)
        return fileExists && isDirectory.boolValue
    }
}
