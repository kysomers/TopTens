//
//  AddFriendsToTopTenTableViewController.swift
//  TopTens
//
//  Created by Kyle Somers on 8/15/17.
//  Copyright © 2017 Kyle Somers. All rights reserved.
//

import UIKit

class AddFriendsToTopTenTableViewController: UITableViewController {

    var topTenPost : TopTenPost?
    var alreadyAdded = [User]()
    var unaddedFriends = [User]()
    var newlyAdded = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.redoSocialArrays), name: NSNotification.Name(rawValue: Constants.Notifications.fetchedUsersForPost), object: nil)


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        redoSocialArrays()
    }
    
    func redoSocialArrays(){
        guard let topTenPost = topTenPost else {return}
        
        alreadyAdded = []
        unaddedFriends = []
        
        for aUser in User.current.friends{
            
            if aUser.uid == User.current.uid{
                continue
            }
            if topTenPost.allUsersForPost.contains(where:{$0.uid == aUser.uid}){
                alreadyAdded.append(aUser)
            }
            else{
                unaddedFriends.append(aUser)
            }
        }
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func doneButtonTapped(_ sender: Any) {
        //Add users in newlyAdded to existing top ten post
        guard let topTenPost = topTenPost else{self.dismiss(animated: true, completion: nil) ; return}
        
        TopTenPostService.addUsersToExistingTopTenPost(users: newlyAdded, topTenPost: topTenPost, success: {succeeded in
            if succeeded{
                TopTenPostService.fetchUsersForTopTenPostAndPostNotification(topTenPost: topTenPost, completion: {(users) in
                    topTenPost.allUsersForPost = users
                    
                })
            }
            
            self.dismiss(animated: true, completion: nil)
            
            
            
        
        })
        
        
        //Don't do this here, but don't forget to do it in the callback
        //topTenPost.usersUIDs.append(aUser.uid)
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0{
            return unaddedFriends.count
        }
        else{
            return alreadyAdded.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! FriendTableViewCell
        
        if indexPath.section == 0{
            let curUser = unaddedFriends[indexPath.row]
            cell.nameLabel.text = curUser.fullName
            cell.usernameLabel.text = curUser.stylizedUsername
            if newlyAdded.contains(curUser){
                cell.addedImageView.isHidden = false

            }
            else{
                cell.addedImageView.isHidden = true
            }
            setCellElementsToColor(cell: cell, color: .black)
            
        }
        else{
            let curUser = alreadyAdded[indexPath.row]
            cell.nameLabel.text = curUser.fullName
            cell.usernameLabel.text = curUser.stylizedUsername
            cell.addedImageView.isHidden = false
            setCellElementsToColor(cell: cell, color: .gray)


        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        if indexPath.section == 0{
            let curUser = unaddedFriends[indexPath.row]
            if newlyAdded.contains(curUser){
                newlyAdded.remove(at: newlyAdded.index(of: curUser)!)
            }
            else{
                newlyAdded.append(curUser)
            }
        }
        tableView.reloadData()
    }
    
    func setCellElementsToColor(cell : FriendTableViewCell,color : UIColor){
        cell.nameLabel.textColor = color
        cell.usernameLabel.textColor = color
        cell.addedImageView.tintColor = color
        cell.addedImageView.image = cell.addedImageView.image?.withRenderingMode(.alwaysTemplate)

    }
    



}
