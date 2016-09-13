//
//  UIViewControllerExtension.swift
//  Cloud Player
//
//  Created by Nikola Majcen on 13/09/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit
import MBProgressHUD

extension UIViewController {
    
    func showSpinner() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    }
    
    func showSpinnerWithText(text: String) {
        let spinner = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        spinner.label.text = text
        
    }
    
    func hideSpinner() {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
    }
}