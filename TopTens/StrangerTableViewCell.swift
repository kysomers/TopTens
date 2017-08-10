//
//  StrangerTableViewCell.swift
//  TopTens
//
//  Created by Kyle Somers on 8/8/17.
//  Copyright © 2017 Kyle Somers. All rights reserved.
//

import UIKit

class StrangerTableViewCell: UITableViewCell {

    var user : User?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func addFriendButtonTapped(_ sender: Any) {
    
        guard let user = user else {return}
        FriendService.sendRequestFromCurrentUser(toUser: user, succeeded: { success in
            if success{
                User.current.sentRequests.append(user)
                
            }
            
            
        })
        addButton.titleLabel?.text = "Added"
        addButton.isEnabled = false
        
    
    }

}
