//
//  PendingFriendTableViewCell.swift
//  TopTens
//
//  Created by Kyle Somers on 8/8/17.
//  Copyright © 2017 Kyle Somers. All rights reserved.
//

import UIKit

class PendingFriendTableViewCell: UITableViewCell {
    
    var user : User?
    var acceptRequestButtonTapped = false
    var declineRequestButtonTapped = false
    var tableViewUpdater : updateTableViewDelegate?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func acceptRequestButtonTapped(_ sender: Any) {
        
        guard let user = user,
            !acceptRequestButtonTapped
            else {return}
        acceptRequestButtonTapped = true
        FriendService.confirmFriend(addedFriend: user, succeeded: {didSucceed in
            if didSucceed{
                User.current.friends.append(user)
                if let userIndex = User.current.receivedRequests.index(of: user){
                    User.current.receivedRequests.remove(at: userIndex)
                }
                if let userIndex = User.current.sentRequests.index(of: user){
                    User.current.sentRequests.remove(at: userIndex)
                }
                DispatchQueue.main.async {
                    self.tableViewUpdater?.updateTableView()

                }
                
            }
        
        })

    
    }
    
    @IBAction func declineRequestButtonTapped(_ sender: Any) {
        guard let user = user,
            !declineRequestButtonTapped
            else {return}
        declineRequestButtonTapped = true
        FriendService.declinePerson(declinedPerson: user, succeeded: {didSucceed in
            if didSucceed{
                if let userIndex = User.current.receivedRequests.index(of: user){
                    User.current.receivedRequests.remove(at: userIndex)
                }
                if let userIndex = User.current.sentRequests.index(of: user){
                    User.current.sentRequests.remove(at: userIndex)
                }
                self.tableViewUpdater?.updateTableView()
                DispatchQueue.main.async {
                    self.tableViewUpdater?.updateTableView()
                    
                }
            }
            
        })
    }
}
