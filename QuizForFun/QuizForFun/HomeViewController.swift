//
//  HomeViewController.swift
//  QuizForFun
//
//  Created by ShaneGoh on 17/11/20.
//

import UIKit
import CoreData

// protocol used for sending data back
protocol HomeViewControllerDelegate: class {
    func displayThird(username: String)
}


class HomeViewController: UIViewController, DataEnteredDelegate, DataEnteredDelegate2, DataEnteredDelegate3 {

    @IBOutlet weak var logOutButton: UIBarButtonItem!
    @IBOutlet weak var instruction: UIBarButtonItem!
    
    @IBOutlet weak var mathImageView: UIImageView!
    @IBOutlet weak var geoImageView: UIImageView!
    @IBOutlet weak var litImageView: UIImageView!
    
    //Retrieving data from LoginViewController using segue
    var usernameText = String()
    var passwordText = String()
    var emailText = String()
    
    //Some declartion variables for animation
    var mathImages = [UIImage]()
    var geoImages = [UIImage]()
    var litImages = [UIImage]()
    
    @IBOutlet weak var displayText: UILabel!
    
    //Default totalpoints as nothing
    var totalpoints = ""
    
    var delegate:HomeViewControllerDelegate? = nil
    
    let managedObjectContext = (UIApplication.shared.delegate as!
                            AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad() {
        super.viewDidLoad()
 
        //Notify user sucessful login
        let alert = UIAlertController(title: "Successfully Log in!", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        //Append all animation images for math
        for i in 0...4 {
            mathImages.append(UIImage(named: "m\(i)")!)
        }
        
        mathImageView.animationImages = mathImages
        mathImageView.animationDuration = 2        //Repeat forever
        mathImageView.animationRepeatCount = 0
        mathImageView.startAnimating()             //Start
        
        //Append all animation images for literature
        for i in 0...7 {
            litImages.append(UIImage(named: "l\(i)")!)
        }
        
        litImageView.animationImages = litImages
        litImageView.animationDuration = 2         //Repeat forever
        litImageView.animationRepeatCount = 0
        litImageView.startAnimating()              //Start
        
        //Append all animation images for literature
        for i in 0...6 {
            geoImages.append(UIImage(named: "gg\(i)")!)
        }
        
        geoImageView.animationImages = geoImages
        geoImageView.animationDuration = 2        //Repeat forever
        geoImageView.animationRepeatCount = 0
        geoImageView.startAnimating()             //Start
    }
    

    @IBAction func logOutAction(_ sender: Any)
    {
        let alert = UIAlertController(title: "\(usernameText)", message: "Are you sure you want to log out?", preferredStyle: UIAlertController.Style.alert)
       
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil ))
        let lg = UIAlertAction(title: "Log Out", style: UIAlertAction.Style.default, handler: {action in
            //Sent Data back
            self.delegate?.displayThird(username : self.usernameText)
            self.navigationController?.popToRootViewController(animated: true)
        })
        lg.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(lg)
        
        //Show alert
        self.present(alert, animated: true, completion: nil)
    }
    
    //Override function pass info to SettingViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "settingSegue" {
            //Set destination of segue
            let svc = segue.destination as! SettingViewController
            svc.usernameText = self.usernameText
            svc.passwordText = self.passwordText
            svc.emailText = self.emailText
        
        }
    else if segue.identifier == "playmathSegue"{
        let mvc = segue.destination as! MathViewController
        mvc.usernameText = self.usernameText
        mvc.delegate = self
        }
    else if segue.identifier == "playgeoSegue"{
        let gvc = segue.destination as! GeoViewController
        gvc.usernameText = self.usernameText
        gvc.delegate = self
        }
    else if segue.identifier == "playlitSegue"{
        let lvc = segue.destination as! LitViewController
        lvc.usernameText = self.usernameText
        lvc.delegate = self
        }
    else if segue.identifier == "recordSegue"{
        let rvc = segue.destination as! RecordViewController
        rvc.usernameText = self.usernameText
        }
    
    }
    
    @IBAction func instructAction(_ sender: Any) {
        
        //Message format
        let alertMessage = """
                  Welcome to Quiz 4 Fun!
         • There are 3 types of quizzes:
            Math, Geography & Literature
         • Each quiz have 5 questions.
         • For Mathematics, please enter
            your answer in text provided.
         • For Geography & Literature,
            select 1 option whichever you
            think is correct.
         • Last but not least, good luck
            and let's Quiz 4 Fun!
         """
        //paragraghAlignment
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.left
        
        //Set text to paragraphy style, font size 15
        let displayText = NSMutableAttributedString(
                string: alertMessage,
                attributes: [
                    NSAttributedString.Key.paragraphStyle: paragraphStyle,
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),
                    NSAttributedString.Key.foregroundColor: UIColor.systemRed
                ]
            )
        
        //Show game instructions
        let alert = UIAlertController.init(title: "Game Instructions", message: nil, preferredStyle: UIAlertController.Style.alert)
        // Set message using format above
        alert.setValue(displayText, forKey: "attributedMessage")
        alert.addAction(UIAlertAction(title: "Let's get started!", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    

    
    
    
    
    //All 3 functions are datas send back from GeoViewController, LitViewController & MathViewController
    func userDidEnterInformation(username: String, gamemode: String, points: String, score: String, totalPoints: String, date: Date) {
        
        self.totalpoints = totalPoints
        self.displayText.alpha = 1
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        
        self.displayText.text = "Well done \(username), you have finished the \(gamemode) quiz with \(score) correct and \(String(5 - Int(score)!)) incorrect answers or \(points) points for this attempt. Overall you have \(totalPoints) points."
       }
    
    func userDidEnterInformation2(username: String, gamemode: String, points: String, score: String, totalPoints: String, date: Date) {
        
        self.totalpoints = totalPoints
        self.displayText.alpha = 1
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        
        self.displayText.text = "Well done \(username), you have finished the \(gamemode) quiz with \(score) correct and \(String(5 - Int(score)!)) incorrect answers or \(points) points for this attempt. Overall you have \(totalPoints) points."
       }
    
    func userDidEnterInformation3(username: String, gamemode: String, points: String, score: String, totalPoints: String, date: Date) {
        
        self.totalpoints = totalPoints
        self.displayText.alpha = 1
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        
        self.displayText.text = "Well done \(username), you have finished the \(gamemode) quiz with \(score) correct and \(String(5 - Int(score)!)) incorrect answers or \(points) points for this attempt. Overall you have \(totalPoints) points."
       }
}
