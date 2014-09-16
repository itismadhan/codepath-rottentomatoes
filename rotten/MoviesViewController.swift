//
//  MoviesViewController.swift
//  rotten
//
//  Created by Madhan on 9/11/14.
//  Copyright (c) 2014 Madhan. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate {
    
    @IBOutlet weak var movieTableView: UITableView!
    var movies: [NSDictionary] = []
    var filteredMovies: [NSDictionary] = []
    var refreshControl:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl = UIRefreshControl()
        self.refreshControl.backgroundColor = UIColor.blackColor()
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.movieTableView.addSubview(refreshControl)
        
        movieTableView.delegate = self
        movieTableView.dataSource = self
        movieTableView.backgroundColor = UIColor.blackColor()
        movieTableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        self.loadMoviesAndShowProgressHUD()
    }
    
    func refresh(sender:AnyObject)
    {
        // Code to refresh table view
        self.getMoviesAndLoadTableView()
        self.refreshControl.endRefreshing()
    }
    
    func loadMoviesAndShowProgressHUD() -> Void {
        var hud:MBProgressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Loading movies"
        hud.labelColor = UIColor.whiteColor()
        dispatch.async.bg {
            self.getMoviesAndLoadTableView()
            dispatch.async.main {
                hud.hide(true)
            }
        }
    }
    
    func getMoviesAndLoadTableView() -> Void {
        let ApiKey = "had44zctnt88rqkje2c56y4z"
        let RottenTomatoesURLString = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=" + ApiKey
        var url = NSURL.URLWithString(RottenTomatoesURLString)// Creating URL
        var request = NSURLRequest(URL: url)// Creating Http Request
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{(response:NSURLResponse!, responseData:NSData!, error: NSError!) ->Void in
            if error != nil
            {
                println(error.description)
            }
            else
            {
                let parsedResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(responseData, options: nil, error: nil)
                let dictionary = parsedResult! as NSDictionary
                self.movies = dictionary["movies"] as [NSDictionary]
                self.movieTableView.reloadData()
            }
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchDisplayController!.active {
            self.searchDisplayController?.searchResultsTableView.rowHeight = self.movieTableView.rowHeight
            return self.filteredMovies.count
        } else {
            return self.movies.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = movieTableView.dequeueReusableCellWithIdentifier("MovieCell") as MovieCell
        var movie = NSDictionary()
        if self.searchDisplayController!.active {
            movie = filteredMovies[indexPath.row]
        } else {
            movie = movies[indexPath.row]
        }
        var posters = movie["posters"] as NSDictionary
        var posterUrl = posters["thumbnail"] as String
        
        cell.accessoryType = UITableViewCellAccessoryType.None
        cell.movieTitleLabel.text = movie["title"] as? String
        cell.synopsisTitleLabel.text = movie["synopsis"] as? String
        cell.movieID = movie["id"] as? Int
        setImageForCellImageView(cell, indexPath: indexPath)
        return cell
    }
    
    func setImageForCellImageView(cell:MovieCell, indexPath:NSIndexPath) -> Void {
        var movie = NSDictionary()
        if self.searchDisplayController!.active {
            movie = filteredMovies[indexPath.row]
        } else {
            movie = movies[indexPath.row]
        }
        var posters = movie["posters"] as NSDictionary
        var posterUrl = posters["thumbnail"] as String
        let profileImageURL = posterUrl.stringByReplacingOccurrencesOfString("tmb", withString: "pro", options: NSStringCompareOptions.LiteralSearch, range:nil)
        let placeHolderImageUrl = NSURL.URLWithString(posterUrl);
        var err: NSError?
        let placeHolderImageData:NSData = NSData.dataWithContentsOfURL(placeHolderImageUrl,options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)
        let placeHolderImage:UIImage = UIImage(data: placeHolderImageData)
        cell.movieImageView.setImageWithURLRequest(NSURLRequest(URL: NSURL(string:profileImageURL)), placeholderImage: placeHolderImage,
            success: {(request:NSURLRequest!,response:NSHTTPURLResponse!, image:UIImage!) -> Void in
                UIView.transitionWithView(cell.movieImageView, duration: 0.3, options: UIViewAnimationOptions.TransitionCrossDissolve,animations: {
                    cell.movieImageView.setImageWithURL(NSURL(string: profileImageURL))
                    }, completion: nil)
            }, failure: {
                (request:NSURLRequest!,response:NSHTTPURLResponse!, error:NSError!) -> Void in
        })
        
    }
    
    func tableView(tableView: UITableView, didselectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("movieDetailsSegue", sender: self)
    }
    
    
    func filterContentForSearchText (searchText: String) {
        filteredMovies = movies.filter{
            ($0["title"] as NSString).localizedCaseInsensitiveContainsString("\(searchText)")
        }
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString)
        controller.searchResultsTableView.backgroundColor = UIColor.blackColor()
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "movieDetailsSegue") {
            let movieDetailsVC:MovieDetailsController = segue.destinationViewController as MovieDetailsController
            var indexPath:NSIndexPath
            
            if self.searchDisplayController!.active {
                indexPath = self.searchDisplayController!.searchResultsTableView.indexPathForSelectedRow()!
                let movie = self.filteredMovies[indexPath.row] as NSDictionary
                movieDetailsVC.movie = movie
                self.searchDisplayController!.searchResultsTableView.deselectRowAtIndexPath(indexPath, animated: true)
            } else {
                indexPath = self.movieTableView.indexPathForSelectedRow()!
                var movie = movies[indexPath.row] as NSDictionary
                movieDetailsVC.movie = movie
                self.movieTableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
