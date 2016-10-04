//
//  Top10MovieViewController.swift
//  OMDbMovieProject
//
//  Created by Susan Zheng on 9/16/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class UpcomingMovieViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{
    @IBOutlet weak var topMoviesCollectionView: UICollectionView!
    
    @IBOutlet weak var startSearchButton: UIButton!
    
    let store = MovieDataStore.sharedInstance
 
    override func viewDidLoad()
    {
        super.viewDidLoad()

    
        topMoviesCollectionView.delegate = self
        topMoviesCollectionView.dataSource = self
        
        self.startSearchButton.layer.borderWidth = 1
        self.startSearchButton.layer.borderColor = UIColor.purple.cgColor
        self.startSearchButton.layer.cornerRadius = 10
        self.startSearchButton.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        store.api.getMoviesPlayingInTheaters { (array) in
            OperationQueue.main.addOperation({
                self.topMoviesCollectionView.reloadData()
            })
            
        }
       
        
    }
    
    
    override func viewWillLayoutSubviews()
    {
        super.viewWillLayoutSubviews()
        
        guard let flowLayout = topMoviesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else
        {
            return
        }
        
        if UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation)
        {
            //landscape
        } else {
            //portrait
        }
        
        flowLayout.invalidateLayout()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize
    {
        var itemsCount : CGFloat = 1.0
        if UIApplication.shared.statusBarOrientation != UIInterfaceOrientation.portrait
        {
            itemsCount = 1.0
        }
        return CGSize(width: self.view.frame.width/itemsCount, height: 100/65 * (self.view.frame.width/itemsCount));
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return store.api.upcomingMovie.count
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UpcomingMoviesCollectionViewCell
        
        if let poster = store.api.upcomingMovie[(indexPath as NSIndexPath).row].poster
        {
            cell.movieImageView.isHidden = true
            DispatchQueue.main.async(execute: {
            let stringPosterURL = URL(string: "http://image.tmdb.org/t/p/w500"+poster)
            
            if let url = stringPosterURL
            {
                let dtinternet = try? Data(contentsOf: url)
                
                if let unwrappedImage = dtinternet
                {
                    cell.movieImageView.isHidden = false
                    cell.movieImageView.image = UIImage.init(data: unwrappedImage)
                }
            }
                
            })
            
        }
        cell.movieImageView.image = UIImage.init(named: "pikachu.png")
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "movieTrailerSegue"
        {
            let destinationVC = segue.destination as! MovieTrailerViewController
            
            let indexPath = topMoviesCollectionView.indexPath(for: sender as! UICollectionViewCell)
            
            if let unwrappedIndex = indexPath
            {
                let id = self.store.api.upcomingMovie[(unwrappedIndex as NSIndexPath).row].id
                let title = self.store.api.upcomingMovie[(unwrappedIndex as NSIndexPath).row].title
                let release = self.store.api.upcomingMovie[(unwrappedIndex as NSIndexPath).row].releaseDate
                let overview = self.store.api.upcomingMovie[(unwrappedIndex as NSIndexPath).row].plot
                
                destinationVC.movieID = id
                destinationVC.movieTitle = title
                destinationVC.releaseDate = release
                destinationVC.overview = overview
            }
            
        }
    }
    

}
