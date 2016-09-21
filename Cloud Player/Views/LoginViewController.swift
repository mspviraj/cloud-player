//
//  LoginViewController.swift
//  Cloud Player
//
//  Created by Nikola Majcen on 06/09/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var createAccountButton: UIButton!
    
    // MARK: - Properties
    
    let viewModel = LoginViewModel()
    let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeBindings()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.authorizeClient()
    }
    
    // MARK: - Private methods
    
    private func initializeBindings() {
        loginButton.rx_tap
            .map { [unowned self] _ in
                return self
            }
            .bindTo(viewModel.loginButtonVariable)
            .addDisposableTo(disposeBag)
        
        createAccountButton.rx_tap
            .bindTo(viewModel.createAccountButtonVariable)
            .addDisposableTo(disposeBag)
        
        viewModel.authorizedCliendObservable
            .subscribeNext { [unowned self] _ in
                self.performSegueWithIdentifier("TabBarControllerSegue", sender: nil)
            }
            .addDisposableTo(disposeBag)
    }
}