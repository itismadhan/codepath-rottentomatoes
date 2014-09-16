//
//  MoviesViewController.swift
//  rotten
//
//  Created by Madhan on 9/11/14.
//  Copyright (c) 2014 Madhan. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var movieTableView: UITableView!
    var movies: [NSDictionary] = []
    var refreshControl:UIRefreshControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refersh")
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
        return self.movies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = movieTableView.dequeueReusableCellWithIdentifier("MovieCell") as MovieCell
        var movie = movies[indexPath.row]
        var posters = movie["posters"] as NSDictionary
        var posterUrl = posters["thumbnail"] as String
        
        cell.accessoryType = UITableViewCellAccessoryType.None
        cell.movieTitleLabel.text = movie["title"] as? String
        cell.synopsisTitleLabel.text = movie["synopsis"] as? String
        cell.movieID = movie["id"] as? Int
        
        
        cell.movieImageView.setImageWithURL(NSURL(string: posterUrl))
        return cell
    }
    
    func tableView(tableView: UITableView, didselectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("movieDetailsSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "movieDetailsSegue") {
            var indexPath:NSIndexPath = self.movieTableView.indexPathForSelectedRow()!
            var movie = movies[indexPath.row] as NSDictionary
            let movieDetailsVC:MovieDetailsController = segue.destinationViewController as MovieDetailsController
            
            movieDetailsVC.movie = movie
            self.movieTableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
