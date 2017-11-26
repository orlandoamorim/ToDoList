//
//  SignInSignUpViewController.swift
//  todoListiOS
//
//  Created by Orlando Amorim on 25/11/2017.
//  Copyright © 2017 Orlando Amorim. All rights reserved.
//

import UIKit
import Eureka
import DeviceKit
import Moya

// SignIn | SignUp
class SignInSignUpViewController: FormViewController {
    
    enum OauthType {
        case signIn
        case signUp
    }
    
    var type: OauthType = .signIn
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        verifyToken()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func verifyToken() {
        let defaults = UserDefaults.standard
        if let _ = defaults.object(forKey: "token") {
            self.performSegue(withIdentifier: "Tasks", sender: nil)
        }else {
            setupForm()
        }
    }
    
    private func setupUI() {
        self.title = ToDoList.localizable.common.toDoList.localized
        self.tableView.separatorColor = ToDoListTheme.linkColor
        self.view.backgroundColor = ToDoListTheme.darkerColor
        self.tableView.backgroundColor = ToDoListTheme.darkerColor
        navigationOptions = .Disabled
    }
    
    private func setupForm() {
        
        EmailFloatLabelRow.defaultCellSetup = { cell, row in
            cell.textField.backgroundColor = UIColor.clear
            cell.textLabel?.backgroundColor = UIColor.clear
            cell.backgroundColor = UIColor.clear
            row.cellUpdate({ (cell, row) in
                cell.textField.textColor = .white
            })
        }
        
        PasswordFloatLabelRow.defaultCellSetup = { cell, row in
            cell.textField.backgroundColor = UIColor.clear
            cell.textLabel?.backgroundColor = UIColor.clear
            cell.backgroundColor = UIColor.clear
            row.cellUpdate({ (cell, row) in
                cell.textField.textColor = .white
            })
        }
        
        LabelRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.textColor = .red
            cell.backgroundColor = UIColor.clear
        }
        
        form +++ Section()
            
            <<< EmailFloatLabelRow(ToDoList.localizable.oauth.mail.localized) {
                $0.title = $0.tag
                $0.value = "todolist@todolist.com"
                $0.add(rule: RuleRequired())
                $0.add(rule: RuleEmail(msg: ToDoList.localizable.oauthAlerts.mail.localized))
                $0.validationOptions = .validatesOnChange
                }.onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validationMsg
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }
            
            <<< PasswordFloatLabelRow(ToDoList.localizable.oauth.password.localized) {
                $0.title = $0.tag
                $0.value = "12345678"
                $0.add(rule: RuleRequired(msg: ToDoList.localizable.oauthAlerts.password.localized))
                $0.add(rule: RuleMinLength(minLength: 8, msg: ToDoList.localizable.oauthAlerts.password.localized))
                $0.validationOptions = .validatesOnChange
                }.onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validationMsg
                                $0.cell.height = { 30 }
                                $0.cell.textLabel?.textColor = .red
                                
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }
            
            <<< PasswordFloatLabelRow(ToDoList.localizable.oauth.passwordConfirmation.localized) {
                $0.title = $0.tag
                $0.value = "12345678"
                $0.hidden = type != .signIn ? false : true
                $0.add(rule: RuleRequired(msg: ToDoList.localizable.oauthAlerts.passwordConfirmation.localized))
                $0.add(rule: RuleMinLength(minLength: 8, msg: ToDoList.localizable.oauthAlerts.passwordConfirmation.localized))
                $0.validationOptions = .validatesOnChange
                $0.add(rule: RuleEqualsToRow(form: form, tag: ToDoList.localizable.oauth.password.localized))
                }.onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validationMsg
                                $0.cell.height = { 30 }
                                $0.cell.textLabel?.textColor = .red
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }
            
            /**
             * Sign In or Sign Up
             */
            +++ Section()
            <<< ButtonRow() {
                $0.title = type == .signIn ? ToDoList.localizable.oauth.signIn.localized : ToDoList.localizable.oauth.signUp.localized
                }.cellSetup({ (cell, row) in
                    cell.tintColor = ToDoListTheme.linkColor
                    cell.backgroundColor = UIColor.clear
                }).onCellSelection { cell, row in
                    if row.section?.form?.validate().count == 0 {
                        switch self.type {
                        case .signIn:   self.signIn()
                        case .signUp:   self.signUp()
                        }
                    }
            }
            
            /**
             * Create an Account
             */
            +++ Section()
            <<< ButtonRow() {
                $0.title = ToDoList.localizable.oauth.createAccount.localized
                $0.hidden = type != .signUp ? false : true
                }.cellSetup({ (cell, row) in
                    cell.tintColor = ToDoListTheme.linkColor
                    cell.height = { 25 }
                    cell.textLabel?.font = .systemFont(ofSize: 14)
                    cell.backgroundColor = UIColor.clear
                }).onCellSelection { cell, row in
                    let ss = self.storyboard!.instantiateViewController(withIdentifier: "SignInSignUpViewController") as! SignInSignUpViewController
                    ss.type = .signUp
                    self.navigationController?.pushViewController(ss, animated: true)
            }
        
    }
    
    
    private func signIn() {
        guard let emailRow = form.rowBy(tag: ToDoList.localizable.oauth.mail.localized) as? EmailFloatLabelRow else { return }
        guard let passwordRow = form.rowBy(tag: ToDoList.localizable.oauth.password.localized) as? PasswordFloatLabelRow else { return }
        
        guard let email = emailRow.value else { return }
        guard let password = passwordRow.value else { return }
        
        OauthNetworkAdapter.signIn(email: email, password: password, success: { (token) in
            let defaults = UserDefaults.standard
            if let _ = defaults.object(forKey: "token") {
                defaults.set(token.token, forKey: "token")
            }else {
                defaults.set(token.token, forKey: "token")
            }
            defaults.synchronize()
            self.performSegue(withIdentifier: "Tasks", sender: nil)
            
        }) { (error) in
            if let err = error as? MoyaError, let data = err.response?.data {
                if let oauthError = try? JSONDecoder().decode(ServerMessage.self, from: data) {
                    self.alert(withTitle: ToDoList.localizable.alertType.ops.localized, message: oauthError.message)
                }
            }
        }
    }
    
    private func signUp() {
        guard let emailRow = form.rowBy(tag: ToDoList.localizable.oauth.mail.localized) as? EmailFloatLabelRow else { return }
        guard let passwordRow = form.rowBy(tag: ToDoList.localizable.oauth.password.localized) as? PasswordFloatLabelRow else { return }
        
        guard let email = emailRow.value else { return }
        guard let password = passwordRow.value else { return }
        
        OauthNetworkAdapter.signUp(email: email, password: password, success: { (user) in
            print(user)
        }) { (error) in
            if let err = error as? MoyaError, let data = err.response?.data {
                if let oauthError = try? JSONDecoder().decode(ServerMessage.self, from: data) {
                    self.alert(withTitle: ToDoList.localizable.alertType.ops.localized, message: oauthError.message)

                }
            }
        }

    }
    

    /** Create a pop up */
    private func alert(withTitle title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: ToDoList.localizable.alert.ok.localized , style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
}
