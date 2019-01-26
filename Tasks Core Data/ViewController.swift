//
//  ViewController.swift
//  Tasks Core Data
//
//  Created by José Gil Ramírez S on 1/25/19.
//  Copyright © 2019 José Gil Ramírez S. All rights reserved.
//

import UIKit
import CoreData  //Para usar las funciones de CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    // var tasks: [String] = [] // originalmente era string y luego cambiamos a NSManagedObjects con CoreDate
    var tasks: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "The List"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    @IBAction func addTaskName(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Task", message: "Add a new task", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) {
            [unowned self] action in
                guard
                    let textField = alert.textFields?.first,
                    let nameToSave = textField.text
                    else { return }
            
            //self.tasks.append(nameToSave) // Mandamos llamar la función save que guarda el contexto.
            self.save(name: nameToSave)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    func save(name: String) {
        // Nos traemos el singleton del AppDelegate para acceder al PersistenContainer
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Mandamos llamar la entidad Task que tenemos en el modelo Tasks_Core_Data.xcdatamodelid
        let entity = NSEntityDescription.entity(forEntityName: "Task", in: managedContext)!
        
        let task = NSManagedObject(entity: entity, insertInto: managedContext)
        
        task.setValue(name, forKeyPath: "name")
        
        // Aquí va guardar todo lo que existe en ese momento en el contexto, no solo un task específico
        do {
            try managedContext.save()
            tasks.append(task)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
}

// MARK: UITableViewDataSource
    
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        // cell.textLabel?.text = tasks[indexPath.row] // Al cambiar a NSManagedObject debemos actualizar el acceso
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.value(forKeyPath: "name") as? String
        return cell
    }
    
    
}

