//
//  SignUpViewController.swift
//  QuizForFun
//
//  Created by ShaneGoh on 10/11/20.
//

import UIKit
import CoreData



class SignUpViewController: UIViewController{

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!

    
    let managedObjectContext = (UIApplication.shared.delegate as!
                            AppDelegate).persistentContainer.viewContext
    var frc = NSFetchedResultsController<NSFetchRequestResult>()

    var eData: Data? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        


        //Change colour of placeholders
        emailText.attributedPlaceholder =
            NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        usernameText.attributedPlaceholder =
            NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        passwordText.attributedPlaceholder =
            NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
    }
    

    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
   
    @IBAction func signUpAction(_ sender: Any) {
        
        //Default boolean all true
        var emailInvalid = true
        var nameInvalid = true
        var passInvalid = true
        
        //Loop true the String in emailText, look for spaces
        for userInput in emailText.text!
        {

            if userInput == " "
            {
                emailInvalid = true
                break
            }
            else
            {
                emailInvalid = false
            }
        }
        
        //Loop true the String in usernameText, look for spaces
        for userName in usernameText.text!
        {
       
            if userName == " "
            {
                nameInvalid = true
                break
            }
            else
            {
                nameInvalid = false
            }
        }
        
        //Loop true the String in passwordText, look for spaces
        for userPass in passwordText.text!
        {
           
            if userPass == " "
            {
                passInvalid = true
                break
            }
            else
            {
                passInvalid = false
            }
        }
        
        
        //If any of the entry is contains spaces
        if emailInvalid == true || nameInvalid == true || passInvalid == true
        {
            let alert = UIAlertController(title: "Invalid Input!", message: "No spaces allowed", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        //If all information is filled
        else
        {
            let entity = NSEntityDescription.entity(forEntityName: "Data", in: managedObjectContext)
            let eData = Data(entity: entity!, insertInto: managedObjectContext)
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Data")
            //Check for same username
            request.predicate = NSPredicate (format: "usernameID == %@", self.usernameText.text!.lowercased())
            
            
            do
            {
                   //Fetch
                   let result = try managedObjectContext.fetch(request)
                   //If there is a record
                   if result.count > 0
                   {
                        //Type Casting result as AnyObject
                        let user = (result[0] as AnyObject).value(forKey: "usernameID") as! String
                       
                        if(user == self.usernameText.text!.lowercased())
                        {
                            let alert = UIAlertController(title: "Existing Username!", message: "Please choose another username", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                   }
                   else
                   {
                        //Store information
                        eData.emailID = emailText.text!
                        eData.usernameID = usernameText.text!.lowercased()
                        eData.passwordID = passwordText.text!
                   
                        do
                        {
                            //Save
                            try managedObjectContext.save()
                            //Alert user successfully created account
                            let alert = UIAlertController(title: "Success!", message: "Account Created!", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {_ in
                                self.navigationController?.popViewController(animated: true)
                            }))
                            //Show alert
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                        catch _
                        {
                            print("Failed To Save")
                            //Alert user failed to create account
                            let alert = UIAlertController(title: "Error!", message: "Please try again later", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                            //Show alert
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
            }
            catch _
            {
                print("Error")
            } 
        }
    }
    
}
