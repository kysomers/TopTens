//
//  EditListItemTableViewCell.swift
//  TopTens
//
//  Created by Kyle Somers on 7/27/17.
//  Copyright © 2017 Kyle Somers. All rights reserved.
//

import UIKit

class ListItemTableViewCell: UITableViewCell {

    @IBOutlet weak var moreIndicatorView: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var doubleUpvoteButton: UIButton!
    @IBOutlet weak var upvoteButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        moreIndicatorView.layer.cornerRadius = moreIndicatorView.frame.width / 2
        moreIndicatorView.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

    @IBAction func doubleUpvoteTapped(_ sender: Any) {
        
        
        
    }
    
    @IBAction func upvoteTapped(_ sender: Any) {
        
        
        
    }

}
