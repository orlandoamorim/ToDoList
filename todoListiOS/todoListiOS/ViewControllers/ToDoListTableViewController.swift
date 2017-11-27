//
//  ToDoListTableViewController.swift
//  todoListiOS
//
//  Created by Orlando Amorim on 25/11/2017.
//  Copyright © 2017 Orlando Amorim. All rights reserved.
//

import UIKit
import Moya

class ToDoListTableViewController: UITableViewController {

    var tasks: [[ToDo]] = [[ToDo]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupValues()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func setupButtons() {
        /** Adding an UIBarButtonItem on right side of Navigation Bar - ADD **/
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(createToDo))
        
        let sOut = UIBarButtonItem(image: ToDoList.images.signOut.image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(signOut))
        let ip = UIBarButtonItem(image: ToDoList.images.ip.image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(setupIP))

        navigationItem.leftBarButtonItems = [sOut, ip]
    }

    fileprivate func setupUI() {
        self.title = ToDoList.localizable.common.toDoList.localized
        self.view.backgroundColor = ToDoListTheme.darkerColor
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationItem.largeTitleDisplayMode = .automatic
        }
    }
    
    fileprivate func setupValues() {
        TaskNetworkAdapter.getToDo(success: { (tasks) in
            self.tasks.removeAll()
            let finished = tasks.filter({$0.isCompleted == true})
            let doing = tasks.filter({$0.isCompleted == false})
            if doing.count > 0 {
                self.tasks.append(doing)
            }
            if finished.count > 0 {
                self.tasks.append(finished)
            }
        
            self.tableView.reloadData()
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
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tasks.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasks[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDo", for: indexPath)
        let toDo = tasks[indexPath.section][indexPath.row]
        // Configure the cell...        
        cell.tintColor = .white
        cell.textLabel?.text = toDo.name
        cell.detailTextLabel?.text = ToDoList.localizable.type(rawValue: "type.\(toDo.type.stringValue)")?.localized
        return cell
    }

    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        for i in tasks[section] {
            switch i.isCompleted {
            case true: return ToDoList.localizable.status.finished.localized
            case false:return ToDoList.localizable.status.doing.localized
            }
        }
        return ToDoList.localizable.status.doing.localized
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UpdateToDoViewController()
        vc.toDo = tasks[indexPath.section][indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var toDo = self.tasks[indexPath.section][indexPath.row]
        let completed = UIContextualAction(style: .normal, title: "Done") { (action, sourceView, completionHandler) in
            print("index path of done: \(indexPath)")
            toDo.isCompleted = toDo.isCompleted == true ? false : true
            TaskNetworkAdapter.update(toDo: toDo, success: { (toDo) in
                completionHandler(true)
                self.setupValues()
            }) { (error) in
                if let err = error as? MoyaError, let data = err.response?.data {
                    if let oauthError = try? JSONDecoder().decode(ServerMessage.self, from: data) {
                        completionHandler(true)
                        self.tableView.reloadData()
                        self.alert(withTitle: ToDoList.localizable.alertType.ops.localized, message: oauthError.message)
                    }
                }else {
                    completionHandler(true)
                    self.tableView.reloadData()
                    self.alert(withTitle: ToDoList.localizable.alertType.ops.localized, message: error.localizedDescription)
                }
            }
        }
        completed.image = ToDoList.images.done.image
        completed.backgroundColor = toDo.isCompleted == true ? .red : .blue
        
        let swipeAction = UISwipeActionsConfiguration(actions: [completed])
        swipeAction.performsFirstActionWithFullSwipe = true // This is the line which disables full swipe
        return swipeAction
        
    }
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: ToDoList.localizable.alert.delete.localized) { (action, sourceView, completionHandler) in
            print("index path of delete: \(indexPath)")
            let toDo = self.tasks[indexPath.section][indexPath.row]
            
            TaskNetworkAdapter.delete(toDo: toDo, success: { (serverMessage) in
                completionHandler(true)
                self.setupValues()
                self.alert(withTitle: serverMessage.message, message: "")
            }) { (error) in
                if let err = error as? MoyaError, let data = err.response?.data {
                    if let oauthError = try? JSONDecoder().decode(ServerMessage.self, from: data) {
                        completionHandler(true)
                        self.tableView.reloadData()
                        self.alert(withTitle: ToDoList.localizable.alertType.ops.localized, message: oauthError.message)
                    }
                }else {
                    completionHandler(true)
                    self.tableView.reloadData()
                    self.alert(withTitle: ToDoList.localizable.alertType.ops.localized, message: error.localizedDescription)
                }
            }
        }

        let swipeAction = UISwipeActionsConfiguration(actions: [delete])
        swipeAction.performsFirstActionWithFullSwipe = true // This is the line which disables full swipe
        return swipeAction
    }


    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    /** Create a pop up */
    fileprivate func alert(withTitle title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: ToDoList.localizable.alert.ok.localized , style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc fileprivate func createToDo() {
        let vc = AddToDoViewController()
        let nc = UINavigationController(rootViewController: vc)
        if #available(iOS 11.0, *) {
            nc.navigationBar.prefersLargeTitles = true
            nc.navigationItem.largeTitleDisplayMode = .automatic
        }
        present(nc, animated: true, completion: nil)
    }
    
    @objc fileprivate func signOut() {
        let defaults = UserDefaults.standard
        if let _ = defaults.object(forKey: "token") {
            defaults.removeObject(forKey: "token")
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        }
    }
    
    @objc fileprivate func setupIP() {
        let alertController = UIAlertController(title: "IP:PORT", message: "Digite o endereço IP e a PORTA do Servidor", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: ToDoList.localizable.alert.ok.localized, style: .default) { (_) in
            if let field = alertController.textFields?[0], let ip = field.text {
                let defaults = UserDefaults.standard
                if let _ = defaults.object(forKey: "ip") {
                    defaults.set(ip, forKey: "ip")
                    defaults.synchronize()
                    self.setupValues()
                }else {
                    defaults.set(ip, forKey: "ip")
                    defaults.synchronize()
                    self.setupValues()
                }
            } else {
                // user did not fill field
                self.setupValues()
            }
        }
        
        let cancelAction = UIAlertAction(title: ToDoList.localizable.alert.cancel.localized, style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "192.168.0.1:3000"
            textField.keyboardType = .numbersAndPunctuation
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
