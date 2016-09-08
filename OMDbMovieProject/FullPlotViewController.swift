//
//  FullPlotViewController.swift
//  OMDbMovieProject
//
//  Created by Flatiron School on 9/7/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class FullPlotViewController: UIViewController {

    var fullPlotString = ""
    @IBOutlet weak var fullPlotSummaryLabel: UILabel!
    
    var ombdMovieStore = OMDbAPIClient.sharedInstance
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        ombdMovieStore.getMovieFullPlot(fullPlotString) { (dictionary) in
            self.fullPlotSummaryLabel.text = dictionary["Plot"] as? String
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
