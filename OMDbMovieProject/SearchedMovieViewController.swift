//
//  SearchedMovieViewController.swift
//  OMDbMovieProject
//
//  Created by Susan Zheng on 9/6/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class SearchedMovieViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate
{
    
    @IBOutlet weak var moviesSearchBar: UISearchBar!
    @IBOutlet weak var movieCollectionView: UICollectionView!
    
    var movieID: String = ""


    var omdbMovie = OMDbAPIClient.sharedInstance
    
    override func viewDidLoad()
    {
        moviesSearchBar.delegate = self
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        movieCollectionView.backgroundColor = UIColor(white: 0.5, alpha: 0.2)
    
        moviesSearchBar.showsCancelButton = true
        super.viewDidLoad()
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.omdbMovie.movieArray.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath) as! SearchedMovieCollectionViewCell
        
        let stringPosterUrl = NSURL(string: self.omdbMovie.movieArray[indexPath.row].poster)
        
        if let url = stringPosterUrl
        {
            let dtinternet = NSData(contentsOfURL: url)
            
            if let unwrappedImage = dtinternet
            {
                cell.moviePosterImageView.image = UIImage.init(data: unwrappedImage)
            }
        }
        if self.omdbMovie.movieArray[indexPath.row].poster == "N/A"
        {
            cell.moviePosterImageView.image = UIImage.init(named: "pikachu.png")
        }
        
        return cell

    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        self.movieID = self.omdbMovie.movieArray[indexPath.row].imdbID
        
        self.performSegueWithIdentifier("movieDetailSegue", sender: self.movieID)
        
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath)
    {
        if indexPath.row == self.omdbMovie.movieArray.count - 1
        {
            if let searchText = moviesSearchBar.text
            {
                self.omdbMovie.OMDbSearchAPIcall(searchText, completion: { (array) in
                    dispatch_async(dispatch_get_main_queue(),{
                        self.omdbMovie.getNextPage(searchText)
                        self.movieCollectionView.reloadData()
                        
                    })

                })
            }
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        
        let searchResult = moviesSearchBar.text
        guard let unwrappedSearch = searchResult else {return}
        self.omdbMovie.movieArray.removeAll()
        
        omdbMovie.OMDbSearchAPIcall(unwrappedSearch) { (array) in
    
            dispatch_async(dispatch_get_main_queue(),{
    
                self.movieCollectionView.reloadData()
            })
            
        }
        self.moviesSearchBar.resignFirstResponder()
    }

    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar)
    {
        self.omdbMovie.movieArray.removeAll()
    }
   
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
    {
        let searchResult = moviesSearchBar.text
        guard let unwrappedSearch = searchResult else {return}
        
        if unwrappedSearch == ""
        {
            self.omdbMovie.movieArray.removeAll()
            
            dispatch_async(dispatch_get_main_queue(),{
                self.movieCollectionView.reloadData()
            })

        }
        else
        {
            self.omdbMovie.movieArray.removeAll()
            
            omdbMovie.OMDbSearchAPIcall(unwrappedSearch) { (array) in
                dispatch_async(dispatch_get_main_queue(),{
                    self.movieCollectionView.reloadData()
                })
                
            }

        }
        
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar)
    {
        self.moviesSearchBar.resignFirstResponder()
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "movieDetailSegue"
        {
            let destinationVC = segue.destinationViewController as!MovieDetailsViewController
            
            destinationVC.plot = self.movieID
        }
        
        
    }


}
