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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        store.fetchData()
        self.tableView.reloadData()
    
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(true)
        
        store.fetchData()
        self.tableView.reloadData()
        
    }

    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return store.favorites.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("favoritesCell", forIndexPath: indexPath) as! FavoritesMovieTableViewCell

        let favMovie = store.favorites[indexPath.row].movies
        
        cell.favMovieTitleLabel.text = favMovie?.first?.title
        cell.favDirectorLabel.text = favMovie?.first?.director
        cell.favReleasedLabel.text = favMovie?.first?.released
        cell.favWriterLabel.text = favMovie?.first?.writer
      
        let imageString = favMovie?.first?.poster
        
        if let unwrappedString = imageString
        {
            if unwrappedString == "N/A"
            {
                cell.favMoviePosterImage.image = UIImage.init(named: "pikachu.png")
            }
            let stringPosterUrl = NSURL(string: unwrappedString)
            if let url = stringPosterUrl
            {
                let dtinternet = NSData(contentsOfURL: url)
                
                if let unwrappedImage = dtinternet
                {
                    cell.favMoviePosterImage.image = UIImage.init(data: unwrappedImage)
                }
            }
            
        }
       
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == UITableViewCellEditingStyle.Delete
        {

            let context = store.managedObjectContext
            context.deleteObject(store.favorites[indexPath.row])
            
            store.favorites.removeAtIndex(indexPath.row)
            store.saveContext()
            
            self.tableView.reloadData()
        }
    }

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
   
        if segue.identifier == "favoritesSegueToDetails"
        {
            let destinationVC = segue.destinationViewController as? MovieDetailsViewController
            
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
            
            if let unwrappedIndex = indexPath
            {
                let movieID = self.store.favorites[unwrappedIndex.row].movies
                guard let movieTitle = movieID?.first else {return}
    
                guard let destinationVC = destinationVC else {return}
                destinationVC.movie = movieTitle
                
            }
            
        }
       
    }
    

}
