//
//  User.swift
//  Sense
//
//  Created by Orlando Amorim on 04/11/2017.
//  Copyright © 2017 InfoWay. All rights reserved.
//

import UIKit

struct User: Codable {
    var id: String
    var created: String
    var email: String
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case created
        case email
        case name = "fullName"
    }
}


struct Token: Codable {
    var token: String
}

