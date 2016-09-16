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
        if isMainDirectoryCreated(directoryPath as String) == false {
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
        do {
            try fileManager.removeItemAtPath(path)
            return true
        } catch let error as NSError {
            print(error.description)
            return false
        }
    }
    
    // MARK: - Private methods
    
    func createMainDirectory(path: String) {
        do {
            try fileManager.createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    func isMainDirectoryCreated(path: String) -> Bool {
        var isDirectory : ObjCBool = false
        let fileExists = fileManager.fileExistsAtPath(path, isDirectory: &isDirectory)
        return fileExists && isDirectory
    }
}