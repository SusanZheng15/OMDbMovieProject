//
//  FullPlotViewController.swift
//  OMDbMovieProject
//
//  Created by Susan Zheng on 9/7/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class FullPlotViewController: UIViewController
{
    var movie: Movie?
    
    let omdbMovie = MovieDataStore.sharedInstance
    
    
    @IBOutlet weak var fullPlotSummaryTextField: UITextView!
    var ombdMovieStore = OMDbAPIClient.sharedInstance
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = "Full Plot Description"
        guard let unwrappedMovie = movie else {return}
        
        self.omdbMovie.getFullSummary(unwrappedMovie)
        {
            dispatch_async(dispatch_get_main_queue(),{
                self.fullPlotSummaryTextField.text = self.movie?.fullSummary
            })
        }

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    
    }

}
