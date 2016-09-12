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

    private let authorizedClientSubject = BehaviorSubject(value: Dropbox.authorizedClient)
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    init() {
        loginButtonVariable.asObservable()
            .skip(1)
            .subscribeNext { Dropbox.authorizeFromController($0) }
            .addDisposableTo(disposeBag)
        
        createAccountButtonVariable.asObservable()
            .skip(1)
            .subscribeNext {
                let url = NSURL(string: "https://www.dropbox.com/m/register")!
                UIApplication.sharedApplication().openURL(url)
            }
            .addDisposableTo(disposeBag)
        
        authorizedCliendObservable = authorizedClientSubject.asObservable()
            .filter { $0 != nil }
            .map { $0! }
    }
    
    // MARK: - Methods
    
    func authorizeClient() {
        authorizedClientSubject.onNext(Dropbox.authorizedClient)
    }
}