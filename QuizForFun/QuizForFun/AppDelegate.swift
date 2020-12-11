//
//  AppDelegate.swift
//  QuizForFun
//
//  Created by ShaneGoh on 10/11/20.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions:
                        [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //Load questions for once
        preloadData()
        //removeAll()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    
    func preloadData()
    {
     
        //Set a key name didPreloadData
        let preloadedDataKey = "didPreloadData"
        
        //For setting a flag for boolean
        let userDefaults = UserDefaults.standard
        
        //Enable this to force loading of data
        //userDefaults.set(false, forKey: preloadedDataKey)
        
        let backgroundContext = persistentContainer.newBackgroundContext()
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        
        backgroundContext.perform {
          
            //If its the first time loading data, do
            if userDefaults.bool(forKey: preloadedDataKey) == false {
                //Preload
                
                //------------------------------------For Math Quiz-----------------------------------------//
                //Take path from MathQuestion
                guard let  mathQ = Bundle.main.url(forResource: "MathQuestion", withExtension: "plist") else {
                    return
                }
                //Take path from MathAnswerSheet
                guard let  mathAS = Bundle.main.url(forResource: "MathAnswerSheet", withExtension: "plist") else {
                    return
                }
                
                
                //------------------------------------For Geo Quiz-----------------------------------------//
                //Take path from GeoQuestion.plist
                guard let  geoQ = Bundle.main.url(forResource: "GeoQuestion", withExtension: "plist") else {
                    return
                }
                //Take path from GeoAnswer.plist
                guard let  geoA = Bundle.main.url(forResource: "GeoAnswer", withExtension: "plist") else {
                    return
                }
                //Take path from GeoAnswerSheet.plist
                guard let  geoAS = Bundle.main.url(forResource: "GeoAnswerSheet", withExtension: "plist") else {
                    return
                }
                
                //------------------------------------For lit Quiz-----------------------------------------//
                //Take path from GeoQuestion.plist
                guard let  litQ = Bundle.main.url(forResource: "LitQuestion", withExtension: "plist") else {
                    return
                }
                //Take path from GeoAnswer.plist
                guard let  litA = Bundle.main.url(forResource: "LitAnswer", withExtension: "plist") else {
                    return
                }
                //Take path from GeoAnswerSheet.plist
                guard let  litAS = Bundle.main.url(forResource: "LitAnswerSheet", withExtension: "plist") else {
                    return
                }

                do
                {
                    //------------------------------------For Math Quiz-----------------------------------------//
                    //Add question
                    let mathQContents = NSArray(contentsOf: mathQ) as? [String]
                    //Add answer
                    let mathASContents = NSArray(contentsOf: mathAS) as? [String]

                    //------------------------------------For Geo Quiz-----------------------------------------//
                    //Add all geo questions into geoQContents
                    let geoQContents = NSArray(contentsOf: geoQ) as? [String]
                    //Add all geo answer options into geoAContents
                    let geoAContents = NSArray(contentsOf: geoA) as? [NSArray]
                    //Add all geo answer sheet into geoASContents
                    let geoASContents = NSArray(contentsOf: geoAS) as? [String]
    
                    //------------------------------------For Lit Quiz-----------------------------------------//
                    //Add all geo questions into geoQContents
                    let litQContents = NSArray(contentsOf: litQ) as? [String]
                    //Add all geo answer options into geoAContents
                    let litAContents = NSArray(contentsOf: litA) as? [NSArray]
                    //Add all geo answer sheet into geoASContents
                    let litASContents = NSArray(contentsOf: litAS) as? [String]
                    
                    
                    //Loop 15 times, load all questions and answers
                    for i in 0...14 {
                            
                            
                            let mathObject = MathQuestion(context: backgroundContext)
                            mathObject.question = mathQContents?[i]
                            mathObject.answer = mathASContents?[i]
                            //print(mathQContents![i])
                        
                            let geoObject = GeoQuestion(context: backgroundContext)
                            geoObject.question = geoQContents?[i]
                            geoObject.option = geoAContents?[i]
                            geoObject.answer = geoASContents?[i]
                            //print(geoAContents![i])
                        
                            let litObject = LitQuestion(context: backgroundContext)
                            litObject.question = litQContents?[i]
                            litObject.option = litAContents?[i]
                            litObject.answer = litASContents?[i]
                            //print(litAContents![i])
                        
                        }
                    
                    //Save all changes
                    try backgroundContext.save()
                    
                    //Set to true once loaded so that no data will be loaded multiple times
                    userDefaults.set(true, forKey: preloadedDataKey)
                }
                catch _
                {
                    print("Error")
                }
   
            }
        }
    }
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "QuizForFun")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func removeAll()
    {
        let context = ( UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
                let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "MathQuestion")
                let deleteFetch2 = NSFetchRequest<NSFetchRequestResult>(entityName: "GeoQuestion")
                let deleteFetch3 = NSFetchRequest<NSFetchRequestResult>(entityName: "LitQuestion")
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
                let deleteRequest2 = NSBatchDeleteRequest(fetchRequest: deleteFetch2)
                let deleteRequest3 = NSBatchDeleteRequest(fetchRequest: deleteFetch3)
        
                do
                {
                    try context.execute(deleteRequest)
                    try context.execute(deleteRequest2)
                    try context.execute(deleteRequest3)
                    try context.save()
                }
                catch
                {
                    print ("There was an error")
                }
    }
    
}

