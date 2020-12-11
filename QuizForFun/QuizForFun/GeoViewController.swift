//
//  GeoViewController.swift
//  QuizForFun
//
//  Created by ShaneGoh on 19/11/20.
//

import UIKit
import CoreData
import Foundation

// protocol used for sending data back
protocol DataEnteredDelegate2: class {
    func userDidEnterInformation2(username: String, gamemode: String, points: String, score: String, totalPoints: String, date: Date)
}

class GeoViewController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var showLabel: UILabel!
    
    @IBOutlet weak var option1Button: UIButton!
    @IBOutlet weak var option2Button: UIButton!
    @IBOutlet weak var option3Button: UIButton!
    @IBOutlet weak var option4Button: UIButton!
    
    @IBOutlet weak var showPoints: UILabel!
    @IBOutlet weak var showAmount: UILabel!
    
    //Retrieve data from HomeViewController using segue
    var usernameText = String()
    
    let managedObjectContext = (UIApplication.shared.delegate as!
                            AppDelegate).persistentContainer.viewContext
    
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "GeoQuestion")
    
    //Default question number as 1
    var qNumber = 1
    
    //Default number of correct answer to 0
    var numberOfCorrect = 0
    
    //Default points to zero
    var points = 0
    
    //Array for displaying question
    var storeArray = [Int]()
    var questionCounter = 0
    
    // making this a weak variable so that it won't create a strong reference cycle
    weak var delegate: DataEnteredDelegate2? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        //Generate number
        generate()
        //On load, show first question
        showQuestion()
        
        //Default
        showPoints.text = "Current Point(s): 0"
        showAmount.text = "Total Correct: 0"
    }


    @IBAction func optionAction(_ sender: UIButton) {
        
        //Add question number
        qNumber += 1
        
        do
        {
            //Fetch object
            let result = try managedObjectContext.fetch(request)
            let answer = (result[storeArray[questionCounter - 1]] as AnyObject).value(forKey: "answer") as! String
            let selected = sender.title(for: .normal)
            
            //If selected answer is correct
            if selected == answer
            {
                //Add number of Correct question
                numberOfCorrect += 1
                //Minus points
                points += 5
            }
            else
            {
                //Minus points
                points -= 2
            }
        }
        catch
        {
            print("Error")
        }
        
        //If questions is not max, show questions
        if qNumber <= 5
        {
            //Show next question
            showQuestion()
        }
        //Else if question reached max of 5
        else
        {
            //Update Score
            self.updateScore()
            //Present user points and number of correc questions
            //Add Void in to allow navigation controller to go back after user pressed OK
            let alert = UIAlertController(title: "Finished Attempt", message: "You have completed the quiz. \(numberOfCorrect) correct answer(s) with a total of \(points) point(s)", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                self.navigationController?.popViewController(animated: true) })
            self.present(alert, animated: true, completion: nil)
            
            do
            {
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Record")
                let request2 = NSFetchRequest<NSFetchRequestResult>(entityName: "Data")
                //Find current user
                request.predicate = NSPredicate (format: "usernameID == %@", self.usernameText.lowercased())
                //Find current user
                request2.predicate = NSPredicate (format: "usernameID == %@", self.usernameText.lowercased())
                let result = try self.managedObjectContext.fetch(request)
                let result2 = try self.managedObjectContext.fetch(request2)
                //Count all record
                let numberOfRecord = result.count
                
                //If record exist..
                if numberOfRecord > 0
                {
                    let recordName = (result[numberOfRecord - 1] as AnyObject).value(forKey: "usernameID") as! String
                    let recordGameMode = (result[numberOfRecord - 1] as AnyObject).value(forKey: "gameMode") as! String
                    let recordPoints = (result[numberOfRecord - 1] as AnyObject).value(forKey: "points") as! String
                    let recordScore = (result[numberOfRecord - 1] as AnyObject).value(forKey: "score") as! String
                    let recordDate = (result[numberOfRecord - 1] as AnyObject).value(forKey: "date") as! Date
                    
                    var i = 0
                    var total = 0
                    
                    //Sum up total points
                    for _ in result
                    {
                        let number = (result[i] as AnyObject).value(forKey: "points") as! String
                        total = total + Int(number)!
                        i += 1
                    }
                    (result2[0] as AnyObject).setValue(String(total), forKey: "overallpoints")
                    self.delegate?.userDidEnterInformation2(username: recordName, gamemode: recordGameMode, points: recordPoints, score: recordScore, totalPoints: String(total), date: recordDate)
                    self.navigationController?.popViewController(animated: true)
                }

            }
            catch
            {
                    print("Error")
            }
        }
        
        //Update points
        showPoints.text = "Current Point(s): \(points)"
        showAmount.text = "Total Correct: \(numberOfCorrect)"
    }
    
    func generate()
    {
        var size = 0
        
        while size < 5 {
           
            // generate number
            let temp = generateNumber()
            //Default
            var duplicated = false
            //If number generate for first time
            if size == 0
            {
                storeArray.append(temp)
                //Increment
                size += 1
            }
            else
            {
                //Loop thru all values in array
                for value in storeArray
                {
                    //Compare array value and look for temp
                    //If found duplicated
                    if value == temp
                    {
                        //Set duplicated to true
                        duplicated = true
                        break
                    }
                }
                //If its not duplicated, add
                if duplicated == false
                {
                    storeArray.append(temp)
                    //Increment
                    size += 1
                }
            }
          
        }
    }
    
    func showQuestion()
    {
        do
        {
            let result = try managedObjectContext.fetch(request)
            let question = (result[storeArray[questionCounter]] as AnyObject).value(forKey: "question") as! String
            //Let option be an array consisting of nested array
            let option = (result[storeArray[questionCounter]] as AnyObject).value(forKey: "option") as! NSArray
    
            //Take out all options in the nested array, downcast to String object
            let option1 = option[0] as! String
            let option2 = option[1] as! String
            let option3 = option[2] as! String
            let option4 = option[3] as! String
            
            //Set question number
            questionLabel.text = "Question: \(qNumber)"
            //Set Question title
            showLabel.text = "\(question)"
            
            //Set title of all the buttons
            self.option1Button.setTitle(option1, for: .normal)
            self.option2Button.setTitle(option2, for: .normal)
            self.option3Button.setTitle(option3, for: .normal)
            self.option4Button.setTitle(option4, for: .normal)
   
        }
        catch _
        {
            print("Error")
        }
        
        //Increment
        questionCounter += 1
    }

    //Generate random number
    func generateNumber() -> Int
    {
        //Random integer 0 - 14
        return Int.random(in: 0...14)
    }
    
    func updateScore()
    {
        
        let entity = NSEntityDescription.entity(forEntityName: "Record", in: managedObjectContext)
        let eRecord = Record(entity: entity!, insertInto: managedObjectContext)

        do
        {
            //Insert new information
            eRecord.usernameID = usernameText
            eRecord.gameMode = "\"Geography\"" 
            eRecord.points = String(points)
            eRecord.score = String(numberOfCorrect)
            eRecord.date = Date()
                        
            //Save
            try managedObjectContext.save()
        }
        catch
        {
           print("Error")
        }
         
    }

}
