//
//  ToDoListAPI.swift
//  todoListiOS
//
//  Created by Orlando Amorim on 25/11/2017.
//  Copyright © 2017 Orlando Amorim. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import Alamofire

enum ToDoListAPI {
    case signUp(email: String, password: String)
    case signIn(email: String, password: String)
    case getTasks(accessToken: String)
    case createTask(accessToken: String, toDo: String, type: String)
    case updateTask(toDo: ToDo)
    case deleteTask(toDo: ToDo)
}

extension ToDoListAPI: TargetType {

    var base: String {
        let defaults = UserDefaults.standard
        if let ip = defaults.object(forKey: "ip") as? String, let url = URL(string: ip) {
            return "http://\(url)"
        }
        return "http://192.168.1.101:3000"
        
    }
    var baseURL: URL { return URL(string: base)! }
    
    var path: String {
        switch self {
        case .signUp:
            return "/auth/register"
        case .signIn:
            return "/auth/sign_in"
        case .getTasks, .createTask:
            return "/tasks"
        case .updateTask(let toDo), .deleteTask(let toDo):
            if let url = URL(string: toDo.id) {
                return "/tasks/\(url)"
            }
            return "/tasks"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signUp, .signIn, .createTask:
            return .post
        case .getTasks:
            return .get
        case .updateTask:
            return .put
        case .deleteTask:
            return .delete
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .signUp(let email, let password), .signIn(let email, let password) :
            var parameters = [String: Any]()
            parameters["email"] = email
            parameters["password"] = password
            return parameters
        case .updateTask(let toDo):
            var parameters = [String: Any]()
            parameters["name"] = toDo.name
            parameters["type"] = toDo.type.stringValue
            parameters["isCompleted"] = toDo.isCompleted
            return parameters
        case .createTask(_, let toDo, let type):
            var parameters = [String: Any]()
            parameters["name"] = toDo
            parameters["type"] = type
            return parameters
        case .getTasks(let accessToken):
            var parameters = [String: String]()
            parameters["Authorization"] = "JWT " + accessToken
            return parameters
        case .deleteTask: return nil
        }
    }

    var parameterEncoding: Moya.ParameterEncoding {
        switch self {
        case .signUp, .signIn, .createTask, .updateTask:
            return JSONEncoding.default
        default:
            return URLEncoding.default
        }
    }
    
    var sampleData: Data {
        switch self {
        default:
            return Data()
        }
    }
    
    var task: Task {
        switch self {
        case .deleteTask:
            return .requestPlain
        default:
            return .requestParameters(parameters: parameters!, encoding: parameterEncoding)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        default:
            var parameters = [String: String]()
            parameters["Content-Type"]  = "application/x-www-form-urlencoded"
            return parameters
        }
    }
}

// MARK: Provider Support

private extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
    }
}

func url(_ route: TargetType) -> String {
    return route.baseURL.appendingPathComponent(route.path).absoluteString
}
