//
//  OauthNetworkAdapter.swift
//  todoListiOS
//
//  Created by Orlando Amorim on 25/11/2017.
//  Copyright © 2017 Orlando Amorim. All rights reserved.
//

import Moya
import RxSwift

struct OauthNetworkAdapter {
    
    static let endpointClosure = { (target: ToDoListAPI) -> Endpoint<ToDoListAPI> in
        let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
        return defaultEndpoint.adding(newHTTPHeaderFields: ["Content-Type": "application/x-www-form-urlencoded; charset=utf-8"])
    }
    
    // Get the default Provider
    static let provider = MoyaProvider<ToDoListAPI>(endpointClosure: endpointClosure)
    static var  disposeBag = DisposeBag() // Bag of disposables to release them when view is being deallocated
    
    static func signUp(email: String, password: String, success successCallback: @escaping (User) -> Void, error errorCallback: @escaping (Error) -> Void) {
        provider
            .rx
            .request(ToDoListAPI.signUp(email: email, password: password))
            .filterSuccessfulStatusCodes()
            .map(User.self)
            .subscribe { event in
                switch event {
                case .success(let user):
                    successCallback(user)
                case .error(let error): errorCallback(error)
                }
            }.disposed(by: disposeBag)
    }
    
    static func signIn(email: String, password: String, success successCallback: @escaping (Token) -> Void, error errorCallback: @escaping (Error) -> Void) {
        
        provider
            .rx
            .request(ToDoListAPI.signIn(email: email, password: password))
            .filterSuccessfulStatusCodes()
            .map(Token.self)
            .subscribe { event in
                switch event {
                case .success(let token):
                    successCallback(token)
                case .error(let error): errorCallback(error)
                }
            }.disposed(by: disposeBag)
    }
}
