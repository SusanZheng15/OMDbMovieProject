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
        
    
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        store.fetchData()
        self.tableView.reloadData()
    
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        
        store.fetchData()
        self.tableView.reloadData()
        
    }

    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return store.favorites.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoritesCell", for: indexPath) as! FavoritesMovieTableViewCell

        let favMovie = store.favorites[(indexPath as NSIndexPath).row].movies
        
        cell.favMovieTitleLabel.text = favMovie?.first?.title
        cell.favDirectorLabel.text = favMovie?.first?.director
        cell.favReleasedLabel.text = favMovie?.first?.released
        cell.favWriterLabel.text = favMovie?.first?.writer
      
        let imageString = favMovie?.first?.poster
        
        if let unwrappedString = imageString
        {
            if unwrappedString == "N/A"
            {
                cell.favMoviePosterImage.image = UIImage.init(named: "movieTempPic.png")
            }
            let stringPosterUrl = URL(string: unwrappedString)
            if let url = stringPosterUrl
            {
                let dtinternet = try? Data(contentsOf: url)
                
                if let unwrappedImage = dtinternet
                {
                    cell.favMoviePosterImage.image = UIImage.init(data: unwrappedImage)
                }
            }
            
        }
       
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == UITableViewCellEditingStyle.delete
        {

            let context = store.managedObjectContext
            context.delete(store.favorites[(indexPath as NSIndexPath).row])
            
            store.favorites.remove(at: (indexPath as NSIndexPath).row)
            store.saveContext()
            
            self.tableView.reloadData()
        }
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
   
        if segue.identifier == "favoritesSegueToDetails"
        {
            let destinationVC = segue.destination as? MovieDetailsViewController
            
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
            
            if let unwrappedIndex = indexPath
            {
                let movieID = self.store.favorites[(unwrappedIndex as NSIndexPath).row].movies
                guard let movieTitle = movieID?.first else {return}
    
                guard let destinationVC = destinationVC else {return}
                destinationVC.movie = movieTitle
                
            }
            
        }
       
    }
    

}
