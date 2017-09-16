//
//  SeeFriendsTopTenTableViewController.swift
//  TopTens
//
//  Created by Kyle Somers on 8/15/17.
//  Copyright © 2017 Kyle Somers. All rights reserved.
//

import UIKit

class SeeFriendsTopTenTableViewController: UITableViewController {

    
    var topTenPost : TopTenPost?
    var usersForPostThatArentMe = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.tableView.reloadData), name: NSNotification.Name(rawValue: Constants.Notifications.fetchedUsersForPost), object: nil)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    // MARK: - Table view data source

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        guard let topTenPost = topTenPost else{return 1}
        
        usersForPostThatArentMe = topTenPost.allUsersForPost.filter({$0.uid != User.current.uid})
        if usersForPostThatArentMe.count == 0{
            return 1
        }
        else{
            return usersForPostThatArentMe.count
        }
    
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let _ = topTenPost, usersForPostThatArentMe.count > 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "otherListDudeCell", for: indexPath) as! FriendTableViewCell
            let currentUser = usersForPostThatArentMe[indexPath.row]
            
            cell.nameLabel.text = currentUser.fullName
            cell.usernameLabel.text = currentUser.stylizedUsername
            
            
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "NotSharedCell", for: indexPath)
            return cell


        }
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let topTenPost = topTenPost,
            let selectedRow = tableView.indexPathForSelectedRow?.row,
            let nextVC = segue.destination as? SeeFriendsTopTensViewController
            else{return}
        nextVC.titleText = topTenPost.metadata.title
        let tappedUser = usersForPostThatArentMe[selectedRow]
        //get the list items from the tapped user
        TopTenPostService.fetchListItemsAndUIDsForUser(user: tappedUser, from: topTenPost.metadata, completion: {listItems in
        
            let newTopTen = TopTenPost(listItems: listItems, metadata: topTenPost.metadata)
            nextVC.topTenPost = newTopTen
            
        })
        
        
        
    }
    


    
    
 

}
