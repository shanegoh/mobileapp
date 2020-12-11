//
//  MathViewController.swift
//  QuizForFun
//
//  Created by ShaneGoh on 18/11/20.
//

import UIKit
import CoreData
import Foundation


// protocol used for sending data back
protocol DataEnteredDelegate: class {
    func userDidEnterInformation(username: String, gamemode: String, points: String, score: String, totalPoints: String, date: Date)
}

class MathViewController: UIViewController {

    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var showLabel: UILabel!
    @IBOutlet weak var answerText: UITextField!
    
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var showPoints: UILabel!
    @IBOutlet weak var showAmount: UILabel!
    
    //Retrieve data from HomeViewController using Segue
    var usernameText = String()
    
    let managedObjectContext = (UIApplication.shared.delegate as!
                            AppDelegate).persistentContainer.viewContext
    
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MathQuestion")
    
    //Count number of loops
    var counter = 0
    
    //Count number of correct answers
    var numberOfCorrect = 0
    
    //Default points to zero
    var points = 0
    
    //Set question number to default 1
    var qNumber = 1
    
    //Array for displaying question
    var storeArray = [Int]()
    var questionCounter = 0
    
    // making this a weak variable so that it won't create a strong reference cycle
    weak var delegate: DataEnteredDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        //Change colour of placeholder
        answerText.attributedPlaceholder =
            NSAttributedString(string: "Your Answer", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        //generate all unique question
        generate()
        
        //Start to show question
        showQuestion()

        //Default
        showPoints.text = "Current Point(s): 0"
        showAmount.text = "Total Correct: 0"
    }
    

    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    
    @IBAction func checkAction(_ sender: Any) {
        
        //Default
        var invalid = false
        
            do
            {
                //Fetch
                let result = try managedObjectContext.fetch(request)
                
                //If user submit empty text, deemed as incorrect
                if answerText.text == ""
                {
                    //Wrong, minus 2 marks
                    points -= 2
                }
                //If user enter anything except for digits
                else if (Int(answerText.text!) == nil)
                {
                    //Format entered is invalid
                    invalid = true
                    //Show alert
                    let alert = UIAlertController(title: "Invalid Input!", message: "Please enter only digits", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
                //If user entered wrong answer
                else if answerText.text != (result[storeArray[questionCounter - 1]] as AnyObject).value(forKey: "answer") as? String
                {
                    //Wrong, minus 2 marks
                    points -= 2
                }
                //If user entered correct answer
                else
                {
                    //Correct, add 5 marks
                    points += 5
                    numberOfCorrect += 1
                }

                //As long as its valid, next and question have not reach 5
                if invalid == false && qNumber < 5
                {
                    //Increment question Number
                    qNumber += 1
                    //Show new question
                    showQuestion()
                }
                //As long as its valid and have reach max question
                else if invalid == false && qNumber == 5
                {
                    //Update Score
                    self.updateScore()
                    //Show user their points and number of correct questions for this attempt
                    //Add action in to allow navigation controller to go back after user pressed OK
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
                            //Calculate total points
                            for _ in result
                            {
                                let number = (result[i] as AnyObject).value(forKey: "points") as! String
                                total = total + Int(number)!
                                i += 1
                            }
                            //Set total points
                            (result2[0] as AnyObject).setValue(String(total), forKey: "overallpoints")
                            self.delegate?.userDidEnterInformation(username: recordName, gamemode: recordGameMode, points: recordPoints, score: recordScore, totalPoints: String(total), date: recordDate)
                        }

                    }
                    catch
                    {
                            print("Error")
                    }
                }
            }
            catch
            {
                print("Error")
            }
        
        //Update points
        showPoints.text = "Current Point(s): \(points)"
        showAmount.text = "Total Correct: \(numberOfCorrect)"
        
        //Clear Text everytime a question is shown
        answerText.text = ""
}

    
    func generate()
    {
        //Default size as zero
        var size = 0
        
        
        while size < 5 {
           
            // generate number
            let temp = generateNumber()
            //Default
            var duplicated = false
            
            //If number generate for first time, append
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
                //If its not duplicated, append
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

            //Update question number
            questionLabel.text = "Question: \(qNumber)"
            //Show question
            showLabel.text = "\(question)"
        
        }
        catch _
        {
            print("Error")
        }
        //Increment counter
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
            eRecord.gameMode = "\"Math\""
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
