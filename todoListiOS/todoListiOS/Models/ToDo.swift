//
//  Task.swift
//  todoListiOS
//
//  Created by Orlando Amorim on 25/11/2017.
//  Copyright © 2017 Orlando Amorim. All rights reserved.
//

import UIKit

struct ToDo: Codable {
    var id: String
    var user: String
    var name: String
    var type: ToDoList.type
    var isCompleted: Bool
    var createdAt: String
    var date: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case user
        case name
        case type
        case isCompleted
        case createdAt = "created_at"
        case date
    }
}

struct ServerMessage: Codable {
    var message: String
}
