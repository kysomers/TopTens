//
//  EditListItemFooterTableViewCell.swift
//  TopTens
//
//  Created by Kyle Somers on 7/27/17.
//  Copyright © 2017 Kyle Somers. All rights reserved.
//

import UIKit

class ListItemFooterTableViewCell: UITableViewCell {

    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var doubleUpvoteButton: UIButton!
    @IBOutlet weak var upvoteButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
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
