//
//  FileManager.swift
//  Cloud Player
//
//  Created by Nikola Majcen on 16/09/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import Foundation

class FileManager {
    
    // MARK: - Properties
    
    private let fileManager = NSFileManager.defaultManager()
    private let directoryName = "iOSCloudPlayer"
    
    // MARK: - Public methods
    
    func saveFile(name: String, data: NSData) -> String! {
        let rootDirectoryPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
                                                                    .UserDomainMask, true).first! as NSString
        let directoryPath = rootDirectoryPath.stringByAppendingPathComponent(directoryName) as NSString
        if isDirectoryCreated(directoryPath as String) == false {
            createMainDirectory(directoryPath as String)
        }
        
        let path = directoryPath.stringByAppendingPathComponent(name + ".mp3")
        if fileManager.createFileAtPath(path, contents: data, attributes: nil) == true {
            return path
        } else {
            return nil
        }
    }
    
    func removeFile(path: String) -> Bool {
        if fileManager.fileExistsAtPath(path) == false {
            return true
        }
        
        do {
            try fileManager.removeItemAtPath(path)
            return true
        } catch let error as NSError {
            print(error.description)
            return false
        }
    }
    
    func fileExists(song: Song) -> Bool {
        return fileManager.fileExistsAtPath(song.filePath!)
    }
    
    // MARK: - Private methods
    
    private func createMainDirectory(path: String) {
        do {
            try fileManager.createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    private func isDirectoryCreated(path: String) -> Bool {
        var isDirectory : ObjCBool = false
        let fileExists = fileManager.fileExistsAtPath(path, isDirectory: &isDirectory)
        return fileExists && isDirectory
    }
}