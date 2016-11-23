//
//  APIConstants.swift
//  Cloud Player
//
//  Created by Nikola Majcen on 06/09/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import Foundation

class APIConstants {
    
    // MARK: - Properties
    
    static var DropboxAPIKey: String! {
        get {
            return readConfigurationValue(key: "Dropbox", file: "API", type: "plist")
        }
    }
    
    // MARK: - Private functions
    
    static private func readConfigurationValue(key: String ,file: String, type: String) -> String! {
        if let path = Bundle.main.path(forResource: file, ofType: type) {
            let dictionary = NSDictionary(contentsOfFile: path)
            return dictionary?.value(forKey: key) as! String
        } else {
            return nil
        }
    }
}
