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
        
        navigationController?.navigationBar.barTintColor = UIColor.appPurple
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        searchBar.returnKeyType = .done
        searchBar.enablesReturnKeyAutomatically = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateTableView), name: NSNotification.Name(rawValue: Constants.Notifications.refreshedSocialArray), object: nil)

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UserService.refreshSocialArraysForCurrentUser()
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
            UserService.refreshSocialArraysForCurrentUser()
            return
        }

        
        let lowercaseSearchText = searchText.lowercased()
        
        FriendService.findUsersWithUsernamesStartingWith(lowercaseSearchText: lowercaseSearchText, completion: {(users) in
        
            if let users = users{
                self.displayedStrangers = users
                
            }
            else{
                self.displayedStrangers = []
            }
            
            DispatchQueue.main.async {
                self.isShowingFriends = false
                self.tableView.reloadData()
            }
        
        })
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}



extension FindFriendsViewController : UITableViewDelegate, UITableViewDataSource, UpdateTableViewDelegate, SingleCellDeleterDelegate{
    
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
                if receivedRequests.count > 0{
                    return friends.count
                }
                else{
                    return friends.count == 0 ? 1 : friends.count
                }
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
                cell.selectionStyle = .none

                return cell
            }
            else{
                if friends.count != 0{
                    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.friendCell, for: indexPath) as! FriendTableViewCell
                    cell.nameLabel.text = friends[indexPath.row].fullName
                    cell.usernameLabel.text = friends[indexPath.row].stylizedUsername
                    cell.selectionStyle = .none
                    
                    
                    return cell
                }
                else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "NoFriendsCell", for: indexPath)
                    return cell
                }
                
                
            }
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.strangerCell, for: indexPath) as! StrangerTableViewCell
            let curUser = displayedStrangers[indexPath.row]
            cell.nameLabel.text = curUser.fullName
            cell.user = curUser
            cell.usernameLabel.text = curUser.username
            cell.selectionStyle = .none
            cell.deleterDelegate = self
            cell.indexPath = indexPath
            
            if User.current.sentRequests.contains(where: {return $0.username == curUser.username}){
                cell.markRequested(name: curUser.username)
            }
            else{
                cell.markUnrequested()
            }
            
            
            
            
            return cell
        }
        
    }
    
    func updateTableView() {
        self.tableView.reloadData()
    }
    
    func deleteCellAtIndexPath(indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .fade)
        displayedStrangers.remove(at: indexPath.row)

        tableView.endUpdates()
    }
}
