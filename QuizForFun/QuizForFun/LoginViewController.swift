//
//  LoginViewController.swift
//  QuizForFun
//
//  Created by ShaneGoh on 10/11/20.
//

import UIKit
import CoreData


// protocol used for sending data back
protocol LoginViewControllerDelegate: class {
    func displaySecond(username: String)
}


class LoginViewController: UIViewController, HomeViewControllerDelegate {
    
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    
    let managedObjectContext = (UIApplication.shared.delegate as!
                            AppDelegate).persistentContainer.viewContext

    var mail = ""

    var delegate:LoginViewControllerDelegate? = nil
    
    
override func viewDidLoad() {
    super.viewDidLoad()
    
    //Looks for single or multiple taps.
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
    view.addGestureRecognizer(tap)
    
    //Change colour of placeholder
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

    @IBAction func loginAction(_ sender: Any) {
        
        //Get request from Entity "Data"
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Data")
        //Check for same username
        request.predicate = NSPredicate (format: "usernameID == %@", self.usernameText.text!.lowercased())
        
        do{
               //Fetch request with username predicate
               let result = try managedObjectContext.fetch(request)
    
               //If there is a record(Check by counting no. of results, should be 1
               if result.count == 1
               {
                    //Take first index and get value of usernameID and passwordID(Should only be 1 result)
                    let user = (result[0] as AnyObject).value(forKey: "usernameID") as! String
                    let pass = (result[0] as AnyObject).value(forKey: "passwordID") as! String
                    //Needed for SettingViewController
                    self.mail = (result[0] as AnyObject).value(forKey: "emailID") as! String
                
                   //Match user input with data
                    if(user == self.usernameText.text!.lowercased() && pass == self.passwordText.text)
                    {
                        //Since there is no alert blocking the navigation stack, the segue will proceed, which means login succeed
                    }
                    //Else if does not match
                    else
                    {
                        //Alert user that either username or password is wrong
                        let alert = UIAlertController(title: "Login Failed!", message: "Wrong username or password", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    
               }
               //If username does not exists
               else
               {
                    //Alert user that account does not exist, try again or sign up account
                    let alert = UIAlertController(title: "Oops!", message: "Username does not exist. Do you wish to register an account?", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: nil))
                    alert.addAction(UIAlertAction(title: "Sign Up", style: UIAlertAction.Style.default, handler: {action in
                        //Instantiate a view controller called SignUpViewController and push to signUpController(Display SignUpViewController for user to sign up account)
                        let signUpController = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
                        self.navigationController?.pushViewController(signUpController, animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
               }
        }
        catch _
        {
            print("Error")
        }
    
       
    }
    //Override function pass info to HomeViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "homeSegue" {
            //Set destination of segue
            let hvc = segue.destination as! HomeViewController
            hvc.usernameText = self.usernameText.text!.lowercased()
            hvc.passwordText = self.passwordText.text!
            hvc.emailText = self.mail
            hvc.delegate = self
        }
    }
    
    //Function from HomeViewControllDelegate
    func displayThird(username: String) {
        self.delegate?.displaySecond(username: username)
    }
   

    
}
