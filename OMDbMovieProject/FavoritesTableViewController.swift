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
    
    //var movies: Set<Movie> = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navBarUI()
        self.title = "Favorites"
        
        store.fetchData()
        //print(self.store.favorites)
        self.tableView.reloadData()
        
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(true)
        
        store.fetchData()
        self.tableView.reloadData()
        
        for fav in store.favorites {
            print("!!!!!!!! \(fav.movies)")
            print("HAS \(fav.movies?.count) MOVIES IN IT")
            let movies = fav.movies
//            for movie in movies! {
//                print("\(movie.title)")
//            }
            movies?.first?.title
        }
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

        let favMovie = store.favorites[indexPath.row].movies
        
        cell.favMovieTitleLabel.text = favMovie?.first?.title
        cell.favDirectorLabel.text = favMovie?.first?.director
        cell.favReleasedLabel.text = favMovie?.first?.released
        cell.favWriterLabel.text = favMovie?.first?.writer
        
        
      

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
