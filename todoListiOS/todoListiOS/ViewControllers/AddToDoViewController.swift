//
//  AddToDoViewController.swift
//  todoListiOS
//
//  Created by Orlando Amorim on 25/11/2017.
//  Copyright © 2017 Orlando Amorim. All rights reserved.
//

import UIKit
import Eureka
import Moya

class AddToDoViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupForm()
        setupButtons()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func setupUI() {
        self.title = ToDoList.localizable.toDoForm.addToDo.localized
        self.tableView.separatorColor = ToDoListTheme.linkColor
        self.view.backgroundColor = ToDoListTheme.darkerColor
        self.tableView.backgroundColor = ToDoListTheme.darkerColor
        navigationOptions = .Disabled
    }

    fileprivate func setupButtons() {
        /** Adding an UIBarButtonItem on left side of Navigation Bar - ADD **/
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(cancel))
    }
    
    @objc fileprivate func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func setupForm() {
        
        TextFloatLabelRow.defaultCellSetup = { cell, row in
            cell.textField.backgroundColor = UIColor.clear
            cell.textLabel?.backgroundColor = UIColor.clear
            cell.backgroundColor = UIColor.clear
            row.cellUpdate({ (cell, row) in
                cell.textField.textColor = .white
            })
        }
        
        form +++ Section()
            <<< TextFloatLabelRow("ToDo") {
                $0.title = $0.tag
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                }.cellUpdate({ (cell, row) in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                    }
                })
        
            <<< PushRow<String>(ToDoList.localizable.toDoForm.type.localized) {
                $0.title = $0.tag
                $0.options = [ToDoList.type.home.stringValue, ToDoList.type.supermarket.stringValue, ToDoList.type.work.stringValue, ToDoList.type.college.stringValue, ToDoList.type.school.stringValue, ToDoList.type.others.stringValue]
                $0.value = ToDoList.type.others.stringValue
                $0.selectorTitle = ToDoList.localizable.toDoForm.type.localized
                }.onPresent { from, to in
                    to.dismissOnSelection = true
                    to.dismissOnChange = false
                    to.view.layoutSubviews()
                    to.tableView.separatorColor = ToDoListTheme.linkColor
                    to.tableView.tintColor = ToDoListTheme.linkColor
                    to.selectableRowCellUpdate = {cell, _ in
                        cell.tintColor = ToDoListTheme.linkColor
                        cell.textLabel?.textColor = ToDoListTheme.linkColor
                        cell.detailTextLabel?.textColor = ToDoListTheme.linkColor

                        cell.selectionStyle = .none
                    }
                }.cellUpdate({ (cell, row) in
                    cell.tintColor = ToDoListTheme.linkColor
                    cell.textLabel?.textColor = ToDoListTheme.linkColor
                    cell.backgroundColor = UIColor.clear
                })
        
            /**
             * Sign In or Sign Up
             */
            +++ Section()
            <<< ButtonRow() {
                $0.title = ToDoList.localizable.toDoForm.addToDo.localized
                }.cellSetup({ (cell, row) in
                    cell.tintColor = ToDoListTheme.linkColor
                    cell.backgroundColor = UIColor.clear
                }).onCellSelection { cell, row in
                    if row.section?.form?.validate().count == 0 {
                        self.createToDo()
                    }
            }
        
    }

    private func createToDo() {
        guard let toDoRow = form.rowBy(tag: ToDoList.localizable.toDoForm.toDo.localized) as? TextFloatLabelRow else { return }
        guard let typeRow = form.rowBy(tag: ToDoList.localizable.toDoForm.type.localized) as? PushRow<String> else { return }
        
        guard let toDo = toDoRow.value else { return }
        guard let type = typeRow.value else { return }
        TaskNetworkAdapter.addToDo(toDo: toDo, type: type , success: { (toDo) in
            print(toDo)
            self.dismiss(animated: true, completion: nil)
        }) { (error) in
            if let err = error as? MoyaError, let data = err.response?.data {
                if let oauthError = try? JSONDecoder().decode(ServerMessage.self, from: data) {
                    self.alert(withTitle: ToDoList.localizable.alertType.ops.localized, message: oauthError.message)
                }
            }else {
                self.alert(withTitle: ToDoList.localizable.alertType.ops.localized, message: error.localizedDescription)
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
