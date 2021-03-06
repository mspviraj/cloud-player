//
//  UIViewController+Spinner.swift
//  Cloud Player
//
//  Created by Nikola Majcen on 13/09/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit
import MBProgressHUD

extension UIViewController {
    
    // MARK: - Spinner
    
    func showSpinner() {
        _ = MBProgressHUD.showAdded(to: self.view, animated: true)
    }
    
    func showSpinnerWithText(text: String) {
        let spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
        spinner.label.text = text
    }
    
    func hideSpinner() {
        _ = MBProgressHUD.hide(for: self.view, animated: true)
    }
}
