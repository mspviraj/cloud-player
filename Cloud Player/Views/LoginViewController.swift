//
//  LoginViewController.swift
//  Cloud Player
//
//  Created by Nikola Majcen on 06/09/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit
import SwiftyDropbox

class LoginViewController: UIViewController {

    // MARK: - Lifecycle
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if Dropbox.authorizedClient != nil {
            performSegueWithIdentifier("TabBarControllerSegue", sender: nil)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func loginButtonPressed(sender: UIButton) {
        Dropbox.authorizeFromController(self)
    }
    
    @IBAction func createAccountButtonPressed(sender: UIButton) {
        let url = NSURL(string: "https://www.dropbox.com/m/register")!
        UIApplication.sharedApplication().openURL(url)
    }
}