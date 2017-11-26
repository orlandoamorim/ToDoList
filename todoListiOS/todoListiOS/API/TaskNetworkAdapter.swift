//
//  TaskNetworkAdapter.swift
//  todoListiOS
//
//  Created by Orlando Amorim on 25/11/2017.
//  Copyright © 2017 Orlando Amorim. All rights reserved.
//

import Moya
import RxSwift

struct TaskNetworkAdapter {
    
    static let endpointClosure = { (target: ToDoListAPI) -> Endpoint<ToDoListAPI> in
        let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
        let defaults = UserDefaults.standard
        if let token = defaults.object(forKey: "token") as? String {
            return defaultEndpoint.adding(newHTTPHeaderFields: ["Content-Type": "application/x-www-form-urlencoded; charset=utf-8", "Authorization" : "JWT \(token)"])
        }
        return defaultEndpoint.adding(newHTTPHeaderFields: ["Content-Type": "application/x-www-form-urlencoded; charset=utf-8"])
    }
    
    // Get the default Provider
    static let provider = MoyaProvider<ToDoListAPI>(endpointClosure: endpointClosure)
    static var  disposeBag = DisposeBag() // Bag of disposables to release them when view is being deallocated
    
    static func getToDo(success successCallback: @escaping ([ToDo]) -> Void, error errorCallback: @escaping (Error) -> Void) {
        let defaults = UserDefaults.standard
        if let token = defaults.object(forKey: "token") as? String {
            provider
                .rx
                .request(ToDoListAPI.getTasks(accessToken: token))
                .filterSuccessfulStatusCodes()
                .map([ToDo].self)
                .subscribe { event in
                    switch event {
                    case .success(let toDoList):
                        successCallback(toDoList)
                    case .error(let error): errorCallback(error)
                    }
                }.disposed(by: disposeBag)
        }else {
            errorCallback(NSError(domain: "No token found, sign in again", code: 0, userInfo: nil))
        }
    }
    
    static func addToDo(toDo: String, type: String, success successCallback: @escaping (ToDo) -> Void, error errorCallback: @escaping (Error) -> Void) {
        let defaults = UserDefaults.standard
        if let token = defaults.object(forKey: "token") as? String {
            provider
                .rx
                .request(ToDoListAPI.createTask(accessToken: token, toDo: toDo, type: type))
                .filterSuccessfulStatusCodes()
                .map(ToDo.self)
                .subscribe { event in
                    switch event {
                    case .success(let toDo):
                        successCallback(toDo)
                    case .error(let error): errorCallback(error)
                    }
                }.disposed(by: disposeBag)
        }else {
            errorCallback(NSError(domain: "No token found, sign in again", code: 0, userInfo: nil))
        }
    }
    
    static func update(toDo: ToDo, success successCallback: @escaping (ToDo) -> Void, error errorCallback: @escaping (Error) -> Void) {
        let defaults = UserDefaults.standard
        if let _ = defaults.object(forKey: "token") as? String {
            provider
                .rx
                .request(ToDoListAPI.updateTask(toDo: toDo))
                .filterSuccessfulStatusCodes()
                .map(ToDo.self)
                .subscribe { event in
                    switch event {
                    case .success(let toDo):
                        successCallback(toDo)
                    case .error(let error): errorCallback(error)
                    }
                }.disposed(by: disposeBag)
        }else {
            errorCallback(NSError(domain: "No token found, sign in again", code: 0, userInfo: nil))
        }
    }
    
    static func delete(toDo: ToDo, success successCallback: @escaping (ServerMessage) -> Void, error errorCallback: @escaping (Error) -> Void) {
        let defaults = UserDefaults.standard
        if let _ = defaults.object(forKey: "token") as? String {
            provider
                .rx
                .request(ToDoListAPI.deleteTask(toDo: toDo))
                .filterSuccessfulStatusCodes()
                .map(ServerMessage.self)
                .subscribe { event in
                    switch event {
                    case .success(let serverMessage):
                        successCallback(serverMessage)
                    case .error(let error): errorCallback(error)
                    }
                }.disposed(by: disposeBag)
        }else {
            errorCallback(NSError(domain: "No token found, sign in again", code: 0, userInfo: nil))
        }
    }
}
