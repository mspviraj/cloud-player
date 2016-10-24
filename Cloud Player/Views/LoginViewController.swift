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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.authorizeClient()
    }
    
    // MARK: - Private methods
    
    private func initializeBindings() {
        loginButton.rx.tap
            .map { [unowned self] _ in
                return self
            }
            .bindTo(viewModel.loginButtonVariable)
            .addDisposableTo(disposeBag)
        
        createAccountButton.rx.tap
            .bindTo(viewModel.createAccountButtonVariable)
            .addDisposableTo(disposeBag)
        
        viewModel.authorizedCliendObservable
            .subscribe(onNext: { [unowned self] (_) in
                self.performSegue(withIdentifier: "TabBarControllerSegue", sender: nil)
            })
            .addDisposableTo(disposeBag)
    }
}
