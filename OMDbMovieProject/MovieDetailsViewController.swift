//
//  MovieDetailsViewController.swift
//  OMDbMovieProject
//
//  Created by Flatiron School on 9/7/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    var plot: String = ""
    
    let omdbMovie = OMDbAPIClient.sharedInstance
    @IBOutlet weak var moviePlot: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
//        self.omdbMovie.getMovieDetailAPICallWithID(plot) { (dictionary) in
//            print(dictionary)
//        }

        
    }

    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
