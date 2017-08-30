//
//  MyTopTensTableViewCell.swift
//  TopTens
//
//  Created by Kyle Somers on 7/20/17.
//  Copyright © 2017 Kyle Somers. All rights reserved.
//

import UIKit

class MyTopTensTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateCreatedLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
