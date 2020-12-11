//
//  SettingViewController.swift
//  QuizForFun
//
//  Created by ShaneGoh on 15/11/20.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    //Retrieving data from HomeViewController using segue
    var emailText = String()
    var usernameText = String()
    var passwordText = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //When view is loaded, set default name and email
        emailLabel.text =  emailText
        usernameLabel.text = usernameText
    }
    
    
    //Override function pass info to SettingViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "passwordSegue" {
            //Set destination of segue
            let pvc = segue.destination as! PassViewController
            pvc.user = self.usernameText
            pvc.pass = self.passwordText
            pvc.mail = self.emailText
        }
    }

}
