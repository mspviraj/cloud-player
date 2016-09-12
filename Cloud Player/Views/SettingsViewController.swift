//
//  SettingsViewController.swift
//  Cloud Player
//
//  Created by Nikola Majcen on 06/09/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit
import SwiftyDropbox

class SettingsViewController: UIViewController {

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    
    @IBAction func logoutButtonPressed(sender: UIBarButtonItem) {
        Dropbox.unlinkClient()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("LoginViewController")
        UIApplication.sharedApplication().keyWindow?.rootViewController = viewController
    }
}