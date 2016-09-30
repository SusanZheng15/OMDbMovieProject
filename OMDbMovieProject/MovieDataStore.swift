//
//  MovieDataStore.swift
//  OMDbMovieProject
//
//  Created by Susan Zheng on 9/8/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
import CoreData

class MovieDataStore
{
    static let sharedInstance = MovieDataStore()
    
    let api = OMDbAPIClient.sharedInstance
    
    fileprivate init() {}
    
    var movieArray : [Movie] = []
    var topMovies : [Movie] = []
    var favorites: [Favorites] = []    
    
    func getMovieRepositories(_ searched: String, completion: @escaping ()->())
    {
        api.OMDbSearchAPIcall(searched) { (array) in
            
            for dictionary in array
            {
                guard let repoDictionary = dictionary as? NSDictionary else { fatalError("Object in array is of non-dictionary type") }
                
                let movieEntity = NSEntityDescription.entity(forEntityName: "Movie", in: self.managedObjectContext)
                
                guard let entity = movieEntity else {fatalError("entity not working")}
                
                let repo = Movie(dictionary: repoDictionary, entity:entity , managedObjectContext: self.managedObjectContext)

                self.movieArray.append(repo)
            
              
            }
            
            completion()
        }
    }
    

    func getDetailsFor(_ movie: Movie, completion: @escaping ()->())
    {
        api.getMovieDetailAPICallWithID(movie.imdbID!) { (dictionary) in
            movie.updateMovieDetailsFrom(dictionary, completion: { success in
                if success {
                    completion()
                }
            })
        }
    }
    func getFullSummary(_ movie: Movie, completion: @escaping ()->())
    {
        api.getMovieFullPlot(movie.imdbID!) { (dictionary) in
            movie.updateMovieWithFullSummary(dictionary, completion: { (successful) in
                if successful
                {
                    completion()
                }
            })
        }
    }
    
    func saveContext ()
    {
        if managedObjectContext.hasChanges
        {
            do
            {
                try managedObjectContext.save()
            }
            catch
            {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror)")
                abort()
            }
        }
    }
    
    func fetchData()
    {
        
        let userRequest = NSFetchRequest<Favorites>(entityName: "Favorites")
        
        do{
            favorites = try managedObjectContext.fetch(userRequest)
        }
        catch
        {
            print(error)
            favorites = []
        }
        
    }

    
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "movieDataModel", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("movieDataModel.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    //MARK: Application's Documents directory
    // Returns the URL to the application's Documents directory.
    
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.FlatironSchool.SlapChat" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()

   
}

