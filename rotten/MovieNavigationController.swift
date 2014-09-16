//
//  MovieNavigationController.swift
//  rotten
//
//  Created by Madhan Padmanabhan on 9/13/14.
//  Copyright (c) 2014 Madhan. All rights reserved.
//

import UIKit

class MovieNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.barTintColor = UIColor.blackColor()
        self.navigationBar.translucent = true
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationBar.titleTextAttributes = titleDict
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
