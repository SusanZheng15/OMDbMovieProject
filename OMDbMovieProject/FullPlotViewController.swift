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
    @IBOutlet weak var fullPlotActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        omdbMovie.fetchData()
        
        fullPlotActivityIndicator.isHidden = false
        fullPlotActivityIndicator.startAnimating()
        
        checkForFullSummary()
        
        self.title = "Full Plot Description"
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        self.navigationItem.leftBarButtonItem =
            UIBarButtonItem(image: UIImage.init(named: "customBackButton.png"), style: .done, target: self, action: #selector (FullPlotViewController.backButtonPressed))

    }
    
    func backButtonPressed(sender:UIButton)
    {
        navigationController?.popViewController(animated: true)
    }
    
    func checkForFullSummary()
    {
        let userRequest = NSFetchRequest<Favorites>(entityName: "Favorites")
        
        do{
            let object = try omdbMovie.managedObjectContext.fetch(userRequest) 
            
            guard let movieObject = self.movie else {return}
            
            if object.count == 0
            {
                self.omdbMovie.getFullSummary(movieObject)
                {
                    DispatchQueue.main.async(execute: {
                        self.fullPlotSummaryTextField.text = self.movie?.fullSummary
                        self.fullPlotActivityIndicator.isHidden = true
                        self.fullPlotActivityIndicator.stopAnimating()
                    })
                }
            }
            
            for movies in object
            {
                guard let savedMovieID = movies.movies?.first?.imdbID else {return}
                
                if object.count != 0 && savedMovieID == movieObject.imdbID
                {
                    self.fullPlotSummaryTextField.text = movies.movies?.first?.fullSummary
                }
                else if object.count != 0 && savedMovieID != movieObject.imdbID
                {
                    
                    guard let unwrappedMovie = movie else {return}
                    
                    self.omdbMovie.getFullSummary(unwrappedMovie)
                    {
                        DispatchQueue.main.async(execute: {
                            self.fullPlotSummaryTextField.text = self.movie?.fullSummary
                            self.fullPlotActivityIndicator.isHidden = true
                            self.fullPlotActivityIndicator.stopAnimating()
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
