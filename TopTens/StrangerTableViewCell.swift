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
    var indexPath : IndexPath?
    var purpleView = UIView()
    let sentLabel = UILabel()

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    var deleterDelegate : SingleCellDeleterDelegate?
    
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
                self.addButton.isEnabled = false
                User.current.sentRequests.append(user)
                
                DispatchQueue.main.async {
   
                    self.markRequested(name: user.fullName)

                }

            }
            else{
                self.addButton.isHidden = false

            }
            
            
        })
        self.addButton.isHidden = true

        
        
    
    }
    
    func markRequested(name : String){
        purpleView.isHidden = false
        purpleView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        purpleView.backgroundColor = .appPurple
        self.addSubview(purpleView)
        sentLabel.text = "Friend Request Sent to \n" + name
        sentLabel.numberOfLines = 2
        sentLabel.textAlignment = .center
        sentLabel.sizeToFit()
        sentLabel.frame.setCenter(CGPoint(x: purpleView.frame.midX, y:purpleView.frame.midY))
        sentLabel.textColor = .white
        purpleView.addSubview(sentLabel)
        
        //Fix the bugs with this, but it would be cool
        //                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
        //                        // Put your code which should be executed with a delay here
        //                        self.deleterDelegate?.deleteCellAtIndexPath(indexPath: self.indexPath!)
        //
        //                    })
    }
    
    func markUnrequested(){
        purpleView.isHidden = true
    }

}
