//
//  SongsViewController.swift
//  Cloud Player
//
//  Created by Nikola Majcen on 06/09/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit
import SwiftyDropbox

class SongsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let client = Dropbox.authorizedClient {
            client.files.search(path: "", query: "pdf")
                .response({ (results, error) in
                    if results != nil {
                        let _ = results.map { print($0.description) }
                    }
                })
        }
    }
}
