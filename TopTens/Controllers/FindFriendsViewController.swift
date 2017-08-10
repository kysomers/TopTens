//
//  FindFriendsViewController.swift
//  TopTens
//
//  Created by Kyle Somers on 8/7/17.
//  Copyright © 2017 Kyle Somers. All rights reserved.
//

import UIKit
import FirebaseDatabase


class FindFriendsViewController: UIViewController {
    
    var currentSearchString : String?
    var displayedStrangers = [User]()
    var friends = [User]()
    var receivedRequests = [User]()
    var isShowingFriends = true

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateTableView), name: NSNotification.Name(rawValue: Constants.Notifications.refreshedSocialArray), object: nil)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension FindFriendsViewController : UISearchBarDelegate{
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == ""{
            isShowingFriends = true
            displayedStrangers = User.current.friends
            tableView.reloadData()
            return
        }
        
        
        
        
        //This chunk should perhaps be moved to the service layer. It's used to find people given the search string isn't empty
        let lowercaseSearchText = searchText.lowercased()
        
        let ref = Database.database().reference().child("users")
        ref.queryOrdered(byChild: "username").queryLimited(toFirst: 20).queryStarting(atValue: lowercaseSearchText).queryEnding(atValue: lowercaseSearchText + "\u{f8ff}").observeSingleEvent(of: .value, with: {(snapshot) in
            
            self.displayedStrangers = []

            
            guard let snapshotDict = snapshot.value as? [String : Any]
                else{ self.tableView.reloadData()
                    return
            }
            
            var counter = 0
            for (uid, aUserDict) in snapshotDict{
                if let aUserDict = aUserDict as? [String : Any], let newUser = User(dict: aUserDict, uid: uid) {
                    
                    if newUser.username != User.current.username &&
                        !User.current.friends.contains(newUser) &&
                        !User.current.receivedRequests.contains(newUser){
                        
                        self.displayedStrangers.append(newUser)
                        
                        counter += 1
                        if counter == 10{
                            break
                        }

                    }
                    
                }
            }
            self.isShowingFriends = false
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            
        })
        

    }
    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//    }
    
    
}



extension FindFriendsViewController : UITableViewDelegate, UITableViewDataSource, updateTableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        receivedRequests = User.current.receivedRequests
        friends = User.current.friends
        
        if isShowingFriends && receivedRequests.count > 0{
           
            return 2
        }
        else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isShowingFriends{
            if section == 0 && receivedRequests.count > 0{
                return receivedRequests.count
            }
            else{
                return friends.count
            }
        }
        else{
            return displayedStrangers.count

        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isShowingFriends{
            if indexPath.section == 0 && receivedRequests.count > 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.pendingCell, for: indexPath) as! PendingFriendTableViewCell
                cell.nameLabel.text = receivedRequests[indexPath.row].fullName
                cell.tableViewUpdater = self
                cell.user = receivedRequests[indexPath.row]
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.friendCell, for: indexPath) as! FriendTableViewCell
                cell.nameLabel.text = friends[indexPath.row].fullName
                
                return cell
            }
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.strangerCell, for: indexPath) as! StrangerTableViewCell
            cell.nameLabel.text = displayedStrangers[indexPath.row].stylizedUsername
            cell.user = displayedStrangers[indexPath.row]
            
            
            
            return cell
        }
        
    }
    
    func updateTableView() {
        self.tableView.reloadData()
    }
}
