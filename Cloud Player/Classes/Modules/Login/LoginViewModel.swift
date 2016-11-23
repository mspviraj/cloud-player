//
//  LoginViewModel.swift
//  Cloud Player
//
//  Created by Nikola Majcen on 12/09/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyDropbox

class LoginViewModel {
    
    // MARK: - Properties
    
    let loginButtonVariable = Variable<UIViewController>(UIViewController())
    let createAccountButtonVariable = Variable<Void>()
    let authorizedCliendObservable: Observable<DropboxClient>

    private let authorizedClientSubject = BehaviorSubject(value: DropboxClientsManager.authorizedClient)
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    init() {
        loginButtonVariable.asObservable()
            .skip(1)
            .subscribe(onNext: {
                DropboxClientsManager
                    .authorizeFromController(UIApplication.shared,
                                             controller: $0,
                                             openURL: { (url) in
                                                UIApplication.shared.openURL(url)
                    }
                )
            })
            .addDisposableTo(disposeBag)
        
        createAccountButtonVariable.asObservable()
            .skip(1)
            .subscribe (onNext: {
                let url = NSURL(string: "https://www.dropbox.com/m/register")!
                UIApplication.shared.openURL(url as URL)
            })
            .addDisposableTo(disposeBag)
        
        authorizedCliendObservable = authorizedClientSubject.asObservable()
            .filter { $0 != nil }
            .map { $0! }
    }
    
    // MARK: - Methods
    
    func authorizeClient() {
        authorizedClientSubject.onNext(DropboxClientsManager.authorizedClient)
    }
}
