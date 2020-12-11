//
//  PassViewController.swift
//  QuizForFun
//
//  Created by ShaneGoh on 17/11/20.
//

import UIKit
import CoreData

class PassViewController: UIViewController {

    
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var passwordText2: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    
    //Retrieving data from SettingViewController using segue
    var user = String()
    var pass = String()
    var mail = String()
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //Set placeholder colour
        passwordText.attributedPlaceholder =
            NSAttributedString(string: "New Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        passwordText2.attributedPlaceholder =
            NSAttributedString(string: "Confirm Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
     
    @IBAction func updatAction(_ sender: Any) {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Data")
        //Check for same username
        request.predicate = NSPredicate (format: "usernameID == %@", self.user.lowercased())
        
        let newPass = passwordText.text
        let conPass = passwordText2.text
        
        //Default set as invalid boolean
        var passInvalid = true
        
        //Check if newPass String contain spaces
        for np in newPass!
        {

            if np == " "
            {
                passInvalid = true
                break
            }
            else
            {
                passInvalid = false
            }
        }
        
        //Check if conPass String contain spaces
        for cp in conPass!
        {
       
            if cp == " "
            {
                passInvalid = true
                break
            }
            else
            {
                passInvalid = false
            }
        }
        
        //if it is invalid
        if passInvalid == true
        {
            //Show alert
            let alert = UIAlertController(title: "Invalid Format!", message: "New Password cannot contain spaces", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil ))
            self.present(alert, animated: true, completion: nil)
        }
        //If both password matched
        else if newPass == conPass
        {
            do
            {
                //Fetch.. should have only 1 record (unique ID)
                let result = try managedObjectContext.fetch(request)
                //Set new password
                (result[0] as AnyObject).setValue(conPass, forKey : "passwordID")
                //Save
                try managedObjectContext.save()
                
                //Show alert
                let alert = UIAlertController(title: "Success!", message: "Password Changed", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {action in  self.navigationController?.popViewController(animated: true)} ))
                self.present(alert, animated: true, completion: nil)
            }
            catch _
            {
                print("Failed to Update")
            }
        }
        //If both password does not match
        else
        {
            //Show Alert
            let alert = UIAlertController(title: "Failed!", message: "New Password does not match!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: nil ))
            self.present(alert, animated: true, completion: nil)
        }
    
        
    }
}
