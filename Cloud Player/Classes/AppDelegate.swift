//
//  AppDelegate.swift
//  Cloud Player
//
//  Created by Nikola Majcen on 05/09/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit
import SwiftyDropbox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        DropboxClientsManager.setupWithAppKey(APIConstants.DropboxAPIKey)
        if DropboxClientsManager.authorizedClient !=  nil {
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
            window?.rootViewController = viewController
        }
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if let authResult = DropboxClientsManager.handleRedirectURL(url as URL) {
            switch authResult {
            case .success(let token):
                print("Success! User is logged into Dropbox with token: \(token)")
            case .cancel:
                print("Authorization flow was manually canceled by user.")
            case .error(let error, let description):
                print("Error \(error): \(description)")
            }
        }
        return true
    }
}
