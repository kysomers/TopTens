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
    var tableViewUpdater : UpdateTableViewDelegate?

    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var nopeButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let checkImage = UIImage(named: "icons8-Checkmark-100.png")?.withRenderingMode(.alwaysTemplate)
        yesButton.setImage(checkImage, for: .normal)
        
        let xImage = UIImage(named: "XICon.png")?.withRenderingMode(.alwaysTemplate)
        nopeButton.setImage(xImage, for: .normal)
        
        self.tintColor = .white
        
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
                //took this out because they were doubling up
                //User.current.friends.append(user)
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
