//
//  MovieCell.swift
//  rotten
//
//  Created by Madhan on 9/11/14.
//  Copyright (c) 2014 Madhan. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var synopsisTitleLabel: UILabel!
    var movieID:Int!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let selectionColor:UIView = UIView()
        selectionColor.backgroundColor = UIColor.grayColor()
        self.selectedBackgroundView = selectionColor
        self.backgroundColor = UIColor.blackColor()
        movieTitleLabel.textColor = UIColor.whiteColor()
        movieTitleLabel.font = UIFont.boldSystemFontOfSize(12)
        synopsisTitleLabel.textColor = UIColor.whiteColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
