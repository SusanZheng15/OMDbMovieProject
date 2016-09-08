//
//  FullPlotViewController.swift
//  OMDbMovieProject
//
//  Created by Susan Zheng on 9/7/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class FullPlotViewController: UIViewController {

    var fullPlotString = ""
    
    @IBOutlet weak var fullPlotSummaryTextField: UITextView!
    var ombdMovieStore = OMDbAPIClient.sharedInstance
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
            
        self.ombdMovieStore.getMovieFullPlot(self.fullPlotString) { (dictionary) in
            dispatch_async(dispatch_get_main_queue(),{
            self.fullPlotSummaryTextField.text = dictionary["Plot"] as? String
            })
        }

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    
    }

}
