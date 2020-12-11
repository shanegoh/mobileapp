//
//  RecordViewController.swift
//  QuizForFun
//
//  Created by ShaneGoh on 20/11/20.
//

import UIKit
import CoreData

class RecordViewController: UIViewController {

    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var textView: UITextView!
    
    
    let managedObjectContext = (UIApplication.shared.delegate as!
                            AppDelegate).persistentContainer.viewContext
    
    var usernameText = String()
    var finalConcat = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //No sorting, default
        sortFunction(type: "Default")
    }


    
    @IBAction func sortOptions(_ sender: Any) {
        
        switch segmentedControl.selectedSegmentIndex
            {
            //If user select date, sort as date
            case 0: sortFunction(type: "date")
                break
            //If user select Quiz, sort as quiz
            case 1: sortFunction(type: "gameMode")
                break
            default:
                break
        }
    }
    
    func sortFunction(type: String)
    {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Record")
        
        //If it's sort by date or quiz
        if type != "Default"
        {
            //localizedStandardCompare: does a "Finder-like" comparison and in particular treats digits within strings according to their numerical value.
            let sortDescriptor = NSSortDescriptor(key: type, ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
            request.sortDescriptors = [sortDescriptor]
        }
            
            do
            {
                //Look for current username
                request.predicate = NSPredicate (format: "usernameID == %@", self.usernameText.lowercased())
                let result = try managedObjectContext.fetch(request)
                
                var i = 0
                var total = 0
                //Sum up total points
                for _ in result
                {
                    let number = (result[i] as AnyObject).value(forKey: "points") as! String
                    total = total + Int(number)!
                    i += 1
                }
                
                //Set header first
                finalConcat = "Hi \(usernameText), you have earned \(total) points in the following attempts:\n"
                
                var k = 0
                for _ in 0..<result.count
                {
                    let mode = (result[k] as AnyObject).value(forKey: "gameMode") as! String
                    let points = (result[k] as AnyObject).value(forKey: "points") as! String
                    let date = (result[k] as AnyObject).value(forKey: "date") as! Date
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd-MM-yyyy HH:mm"
                    let dateFormat = formatter.string(from: date)
                    
                    let concat = "\(mode) area - attempt started on \(dateFormat) – points earned \(points)\n\n"
                    finalConcat = finalConcat + concat
                    k += 1
                }
                
                //Display all records
                textView.text = self.finalConcat
            }
            catch
            {
                print("Error")
            }
            
    }
    
}
