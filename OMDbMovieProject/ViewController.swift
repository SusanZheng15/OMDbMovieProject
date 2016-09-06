//
//  ViewController.swift
//  OMDbMovieProject
//
//  Created by Susan Zheng on 9/2/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{

    var collectionView: UICollectionView!
    var movieArray : [String] = []

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        OMDbSearchAPI.OMDbSearchAPIcall("love") { (dictionary) in
            
            let movieDictionary = dictionary as? NSDictionary
            
            if let unwrappedMovieDictionary = movieDictionary
            {
                let array = unwrappedMovieDictionary["Search"] as? [String]
                
                if let unwrappedArray = array
                {
                    self.movieArray = unwrappedArray
                }
            }
            
         
        }
        
    }


    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

