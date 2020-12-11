//
//  ViewController.swift
//  QuizForFun
//
//  Created by ShaneGoh on 16/11/20.
//

import UIKit
import CoreData


class ViewController: UIViewController, LoginViewControllerDelegate{
  
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var displayText: UILabel!
    var quizImages = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        //Append all animation images
        for i in 0...14 {
            quizImages.append(UIImage(named: "g\(i)")!)
        }
        
        imageView.animationImages = quizImages
        imageView.animationDuration =  2
        //Repeat forever
        imageView.animationRepeatCount = 0
        //Start
        imageView.startAnimating()
        
    }
    

    //Override function pass info to HomeViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "loginSegue" {
            //Set destination of segue
            let lvc = segue.destination as! LoginViewController
            lvc.delegate = self
        }
    }
    
    //Function inside LoginViewControllerDelegate
    func displaySecond(username: String) {
        let managedObjectContext = (UIApplication.shared.delegate as!
                                AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Data")
        //Find current user
        request.predicate = NSPredicate (format: "usernameID == %@", username.lowercased())
        do
        {
            let result = try managedObjectContext.fetch(request)
           
            //If user do not have any points
            guard let totalPoints = (result[0] as AnyObject).value(forKey: "overallpoints") as? String else
            {
                //Show displaytext for non existing points
                displayText.alpha = 1
                displayText.text = "\(username), you have overall 0 points."
                return
            }
            //Show displaytext
            displayText.alpha = 1
            displayText.text = "\(username), you have overall \(totalPoints) points."
        }
       catch
       {
            print("Error")
       }
    }
    
}



