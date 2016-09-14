//
//  FavoritesTableViewController.swift
//  OMDbMovieProject
//
//  Created by Susan Zheng on 9/12/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import CoreData

class FavoritesTableViewController: UITableViewController
{
    
    let store = MovieDataStore.sharedInstance
    var movies: Set<Movie> = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navBarUI()
        self.title = "Favorites"
        
        store.fetchData()
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(true)
        
        store.fetchData()
        self.tableView.reloadData()
    }

    
    func navBarUI()
    {
        let navBarColor = navigationController!.navigationBar
        
        navBarColor.backgroundColor = UIColor.blueColor()
        navBarColor.alpha = 1.0
        
        navBarColor.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "AppleSDGothicNeo-Light", size: 25)!]
        
    }

    // MARK: - Table view data source



    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return store.favorites.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("favoritesCell", forIndexPath: indexPath) as! FavoritesMovieTableViewCell
//
//       let movieArray = Array(movies)
//       let eachMovie = movieArray[indexPath.row]
//        
//        cell.favMovieTitleLabel.text = movieArray[indexPath.row].title
        
      

        return cell
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
