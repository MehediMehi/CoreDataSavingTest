//
//  ViewController.swift
//  CoreDataSavingTest
//
//  Created by Md. Mehedi Hasan Akash on 1/23/20.
//  Copyright © 2020 Md. Mehedi Hasan Akash. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var showDataTextField: UITextView!
    
    
    var stringVar: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func saveButtonTapped(_ sender: Any) {
        saveData()
        
        retrieveData()
        
    }
    
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        deleteData()
    }
    
    func saveData(){
        var inputName = self.nameTextField.text
        var inputAge = self.ageTextField.text
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let userEntity = NSEntityDescription.entity(forEntityName: "Profile", in: managedContext)
        
        //save data
        if(inputName != "" && inputAge != "")
        {
            let profile = NSManagedObject(entity: userEntity!, insertInto: managedContext)
            profile.setValue(inputName, forKeyPath: "name")
            profile.setValue(inputAge, forKeyPath: "age")
            
            do{
                try managedContext.save()
            } catch let error as NSError{
                print("Error occured! error: \(error), \(error.userInfo)")
            }
        }
    }
    
    func retrieveData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Profile")
        
        do{
            let result = try managedContext.fetch(fetchRequest)
            stringVar = ""
            
            print(result)
            
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "name") as! String)
                var str = data.value(forKey: "name") as? String
                var age = data.value(forKey: "age") as? String
                stringVar += "Name: " + str! + " Age: " + age! + "\n"
                
            }
            self.showDataTextField.text = stringVar
        } catch {
            print("Fail!")
        }
    }
    
    func deleteData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Profile")
        
        let deleteText = nameTextField.text
        
        fetchRequest.predicate = NSPredicate(format: "name = %@", deleteText!)
        
        do{
            let test = try managedContext.fetch(fetchRequest)
            
            for i in test{
                let objectToDelete = i as! NSManagedObject
                managedContext.delete(objectToDelete)
            }
            
            do{
                try managedContext.save()
            }
            catch{
                print(error)
            }
        } catch{
            print(error)
        }
        retrieveData()
    }
    
//    func deleteDuplicateData(){
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Profile")
//
//        var resultsArr
//    }
}

