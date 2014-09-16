//
//  MovieDetailsController.swift
//  rotten
//
//  Created by Madhan Padmanabhan on 9/15/14.
//  Copyright (c) 2014 Madhan. All rights reserved.
//

import UIKit

class MovieDetailsController: UIViewController {

    var movie:NSDictionary!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieDetailsTextView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scrollViewContentHeight = textView.frame.origin.y+textView.frame.size.height;
        
        self.navigationController?.navigationBar.translucent = true
        self.title = movie["title"] as? String
        
        textView.textContainerInset = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, scrollViewContentHeight)
        
        movieDetailsTextView.text = movie["synopsis"] as String
        movieDetailsTextView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
        movieDetailsTextView.textColor = UIColor.whiteColor()
        
        setImageForMovieImageView()
    }
    
    func setImageForMovieImageView() -> Void {
        let posters = movie["posters"] as NSDictionary
        let posterUrl = posters["thumbnail"] as String
        let postersOriginal = posterUrl.stringByReplacingOccurrencesOfString("tmb", withString: "org", options: NSStringCompareOptions.LiteralSearch, range:nil)
        let postersDetailed = posterUrl.stringByReplacingOccurrencesOfString("tmb", withString: "det", options: NSStringCompareOptions.LiteralSearch, range:nil)
        let placeHolderImageUrl = NSURL.URLWithString(postersDetailed);
        var err: NSError?
        let placeHolderImageData:NSData = NSData.dataWithContentsOfURL(placeHolderImageUrl,options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)
        let placeHolderImage:UIImage = UIImage(data: placeHolderImageData)
        
        self.movieImageView.setImageWithURLRequest(NSURLRequest(URL: NSURL(string:postersOriginal)), placeholderImage: placeHolderImage,
            success: {(request:NSURLRequest!,response:NSHTTPURLResponse!, image:UIImage!) -> Void in
                self.movieImageView.setImageWithURL(NSURL(string: postersOriginal))
            }, failure: {
                (request:NSURLRequest!,response:NSHTTPURLResponse!, error:NSError!) -> Void in
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
