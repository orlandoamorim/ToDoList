//
//  Enum+Extensions.swift
//  todoListiOS
//
//  Created by Orlando Amorim on 25/11/2017.
//  Copyright © 2017 Orlando Amorim. All rights reserved.
//

import UIKit

// MARK: - Project Constants
enum ToDoList {
    
    // Image Names
    enum images: String, ImageRepresentable {
        case userIcon           = "login_usuario"
        case passwordIcon       = "login_senha"
        case icon               = "icon"
        case signOut            = "signOut"
        case ip                 = "ip"
        case done               = "done"
    }
    
    enum type: String, Codable, CodingKey {
        case home           = "home"
        case supermarket    = "supermarket"
        case work           = "work"
        case college        = "college"
        case school         = "school"
        case others         = "others"
    }
    
    // Localizable Strings
    enum localizable {
        
        enum common: String, LocalizeRepresentable {
            case toDoList    = "common.toDoList"
        }
        
        enum oauth: String, LocalizeRepresentable {
            case mail                   = "oauth.mail"
            case password               = "oauth.password"
            case passwordConfirmation   = "oauth.passwordConfirmation"
            case userName               = "oauth.userName"
            case signIn                 = "oauth.signIn"
            case signUp                 = "oauth.signUp"
            case signOut                = "oauth.signOut"
            case welcome                = "oauth.welcome"
            case terms                  = "oauth.terms"
            case termsOfUse             = "oauth.termsOfUse"
            case privacyPolicy          = "oauth.privacyPolicy"
            case createAccount          = "ouath.createAccount"
        }
        
        enum oauthAlerts: String, LocalizeRepresentable {
            case password                 = "oauthAlert.password"
            case passwordConfirmation     = "oauthAlert.passwordConfirmation"
            case userName                 = "oauthAlert.userName"
            case userNameExists           = "oauthAlert.userNameExists"
            case mail                     = "oauthAlert.mail"
            case emailPasswordError       = "oauthAlert.emailPasswordError"
        }
        
        // Alert Types
        enum alertType: String, LocalizeRepresentable {
            case change     = "alertType.change"
            case error      = "alertType.error"
            case delete     = "alertType.delete"
            case wait       = "alertType.wait"
            case add        = "alertType.add"
            case update     = "alertType.update"
            case cancel     = "alertType.cancel"
            case createdAt  = "alertType.createdAt"
            case ok         = "alertType.ok"
            case ops        = "alertType.ops"
            case attention  = "alertType.attention"
            case remove     = "alertType.remove"
            case decline    = "alertType.decline"
            case accept     = "alertType.accept"
            case success    = "alertType.success"
        }
        
        enum formFields: String, LocalizeRepresentable {
            case name           = "formFields.name"
            case birthday       = "formFields.birthday"
            case gender         = "formFields.gender"
            case ethnic         = "formFields.ethnic"
            case mail           = "formFields.mail"
            case phoneNumber    = "formFields.phoneNumber"
            case about          = "formFields.about"
            case description    = "formFields.description"
            case startDate      = "formFields.startDate"
            case endDate        = "formFields.endDate"
            case value          = "formFields.value"
            case createdBy      = "formFields.createdBy"
            case report         = "formFields.report"
            case address        = "formFields.address"
            case free           = "formFields.free"
            case location       = "formFields.location"
            case image          = "formFields.image"
            case preview        = "formFields.preview"
            case type           = "formFields.type"
            case contact        = "formFields.contact"
        }
        
        enum formAlerts: String, LocalizeRepresentable {
            case image              = "formAlert.image"
            case name               = "formAlert.name"
            case description        = "formAlert.description"
            case descriptionLimit   = "formAlert.descriptionLimit"
            case address            = "formAlert.address"
            case contact            = "formAlert.contact"
        }
                
        enum alert: String, LocalizeRepresentable {
            case change     = "alert.change"
            case error      = "alert.error"
            case delete     = "alert.delete"
            case wait       = "alert.wait"
            case add        = "alert.add"
            case update     = "alert.update"
            case cancel     = "alert.cancel"
            case createdAt  = "alert.createdAt"
            case ok         = "alert.ok"
        }
        
        enum type: String, LocalizeRepresentable {
            case home           = "type.home"
            case supermarket    = "type.supermarket"
            case work           = "type.work"
            case college        = "type.college"
            case school         = "type.school"
            case others         = "type.others"
        }
        
        enum status: String, LocalizeRepresentable {
            case doing             = "toDoStatus.doing"
            case finished          = "toDoStatus.finished"
        }
        
        enum toDoForm: String, LocalizeRepresentable {
            case addToDo        = "toDoForm.addToDo"
            case updateToDo     = "toDoForm.updateToDo"
            case deleteToDo     = "toDoForm.deleteToDo"
            case toDo           = "toDoForm.toDo"
            case type           = "toDoForm.type"
            case isCompleted    = "toDoForm.isCompleted"
        }
        
        enum toDoFormAlert: String, LocalizeRepresentable {
            case toDo           = "toDoFormAlert.toDo"
        }
        
    }
}


// MARK: - Representable Protocols
protocol ImageRepresentable: RawRepresentable {
    var image: UIImage? { get }
}

protocol LocalizeRepresentable: RawRepresentable {
    var localized: String { get }
}

protocol ColorRepresentable: RawRepresentable {
    var color: UIColor? { get }
}

// MARK: - Representable Protocols Extensions
extension ImageRepresentable where RawValue == String {
    var image: UIImage? {
        return UIImage(named: rawValue)
    }
}

extension LocalizeRepresentable where RawValue == String {
    var localized: String {
        return NSLocalizedString(rawValue, comment: "")
    }
}

extension ColorRepresentable where RawValue == String {
    var color: UIColor? {
        return UIColor(named: rawValue)
    }
}

extension ToDoList.localizable.type {
    var index: Int {
        switch self {
        case .home           : return 0
        case .supermarket    : return 1
        case .work           : return 2
        case .college        : return 3
        case .school         : return 4
        case .others         : return 5
        }
    }
}

extension ToDoList.type {
    var index: Int {
        switch self {
        case .home           : return 0
        case .supermarket    : return 1
        case .work           : return 2
        case .college        : return 3
        case .school         : return 4
        case .others         : return 5
        }
    }
}
