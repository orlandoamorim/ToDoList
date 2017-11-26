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
    
    /*
     
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    /** Create a pop up */
    private func alert(withTitle title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: ToDoList.localizable.alert.ok.localized , style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc private func createToDo() {
        let vc = AddToDoViewController()
        let nc = UINavigationController(rootViewController: vc)
        if #available(iOS 11.0, *) {
            nc.navigationBar.prefersLargeTitles = true
            nc.navigationItem.largeTitleDisplayMode = .automatic
        }
        present(nc, animated: true, completion: nil)
    }
}
