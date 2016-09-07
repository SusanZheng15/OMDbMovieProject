//
//  SearchedMovieViewController.swift
//  OMDbMovieProject
//
//  Created by Susan Zheng on 9/6/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class SearchedMovieViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate, UISearchControllerDelegate
{
    
    @IBOutlet weak var moviesSearchBar: UISearchBar!
    @IBOutlet weak var movieCollectionView: UICollectionView!


    var omdbMovie = OMDbAPIClient.sharedInstance
    
    override func viewDidLoad()
    {
        moviesSearchBar.delegate = self
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
    
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
//        
//        if indexPath.row == self.omdbMovie.movieArray.count - 5
//        {
//            if let searchResults = moviesSearchBar.text
//            {
//                self.omdbMovie.getNextPage(searchResults)
//            }
//            
//        }
        
        let stringUrl = NSURL(string: self.omdbMovie.movieArray[indexPath.row].poster)
        
        if let url = stringUrl
        {
            let dtinternet = NSData(contentsOfURL: url)
            
            if let unwrappedImage = dtinternet
            {
                cell.moviePosterImageView.image = UIImage.init(data: unwrappedImage)
            }
        }
        
        return cell

    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        print("did selected")
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
        print("did u search?")
        self.moviesSearchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar)
    {
        self.omdbMovie.movieArray.removeAll()
        print("did u begin?")
    }
   
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
    {
        let searchResult = moviesSearchBar.text
        guard let unwrappedSearch = searchResult else {return}
        self.omdbMovie.movieArray.removeAll()
        omdbMovie.OMDbSearchAPIcall(unwrappedSearch) { (array) in
                
                dispatch_async(dispatch_get_main_queue(),{
                    self.movieCollectionView.reloadData()
                })
                
            }
        
        
        print("it printed!")
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        print("did u just cancel on me?")
        self.moviesSearchBar.resignFirstResponder()
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
