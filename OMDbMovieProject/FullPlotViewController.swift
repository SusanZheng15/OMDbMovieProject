//
//  FullPlotViewController.swift
//  OMDbMovieProject
//
//  Created by Susan Zheng on 9/7/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import CoreData

class FullPlotViewController: UIViewController
{
    var movie: Movie?
    let omdbMovie = MovieDataStore.sharedInstance
    
    @IBOutlet weak var fullPlotSummaryTextField: UITextView!
 
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        omdbMovie.fetchData()
        
        checkForFullSummary()
        
        self.title = "Full Plot Description"

    }
    
    func checkForFullSummary()
    {
        let userRequest = NSFetchRequest(entityName: "Favorites")
        
        do{
            let object = try omdbMovie.managedObjectContext.executeFetchRequest(userRequest) as! [Favorites]
            
            guard let movieObject = self.movie else {return}
            
            if object.count == 0
            {
                print("nothing in core data")
                self.omdbMovie.getFullSummary(movieObject)
                {
                    dispatch_async(dispatch_get_main_queue(),{
                        self.fullPlotSummaryTextField.text = self.movie?.fullSummary
                    })
                }
            }
            
            for movies in object
            {
                guard let savedMovieID = movies.movies?.first?.imdbID else {return}
                
                if savedMovieID == movieObject.imdbID
                {
                    print("\(movieObject.title) Have summary")
                    self.fullPlotSummaryTextField.text = movies.movies?.first?.fullSummary
                }
                else// if savedMovieID != movieObject.imdbID
                {
                    print("\(movieObject.title) doesnt have summary")
                    
                    guard let unwrappedMovie = movie else {return}
                    
                    self.omdbMovie.getFullSummary(unwrappedMovie)
                    {
                        dispatch_async(dispatch_get_main_queue(),{
                            self.fullPlotSummaryTextField.text = self.movie?.fullSummary
                        })
                    }
                    
                }
                
            }
            
        }
            
        catch{print("Error")}
        
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    
    }

}
