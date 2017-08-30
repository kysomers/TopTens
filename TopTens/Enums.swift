//
//  Enums.swift
//  TopTens
//
//  Created by Kyle Somers on 7/18/17.
//  Copyright © 2017 Kyle Somers. All rights reserved.
//

import Foundation


struct Constants{
    
    struct Segues{
        static let toCreateUsername = "toCreateUsername"
        static let toListItemDetailSegue = "toListItemDetailSegue"
        static let toSeeFriendsTopTenTableViewControllerSegue = "toSeeFriendsTopTenTableViewControllerSegue"
        static let toAddFriendsTableViewControllerSegue = "toAddFriendsTableViewControllerSegue"
    }
    
    struct CellIdentifiers{
        static let topTenListCell = "Top Ten List Cell"
        static let topTenFooterListCell = "Edit Footer Cell"
        static let strangerCell = "strangerCell"
        static let friendCell = "friendCell"
        static let pendingCell = "pendingCell"


    }
    
    struct Notifications{
        static let refreshedSocialArray = "refreshedSocialArray"
        static let fetchedUsersForPost = "fetchedUsersForPost"
    }
    
    struct UserDefaults {
        static let currentUser = "currentUser"
        static let uid = "uid"
        static let username = "username"
        static let stylizedUsername = "stylizedUsername"
        static let fullName = "fullName"
        static let key = "users"
        static let friends = "friends"
        static let sentRequests = "sentRequests"
        static let receivedRequests = "receivedRequests"


    }
    
    struct TopTenPost{
        static let key = "TopTenPosts"
        
    }
    
    struct TopTenShared{
        static let key = "TopTenShared"
        static let deleted = "deleted"
    }
    
    struct TopTenPostMetadata{
        
        static let key = "TopTenPostMetadata"
        static let title = "title"
        static let dateCreated = "dateCreated"
        static let dateModified = "dateModified"
        static let votingType = "votingType"
        static let ownerUID = "ownerUID"
        static let creatorUsername = "creatorUsername"
        static let isShared = "isShared"
        
    }
    
    struct ListItem{
        static let title = "title"
        static let votes = "votes"
        static let position = "position"
        static let ownerUID = "ownerUID"
        static let creatorUsername = "creatorUsername"
        static let dateCreated = "dateCreated"
        static let detailsString = "detailsString"

    }
    
    struct PostUsers{
        static let key = "PostUsers"
        static let fullname = UserDefaults.fullName
        static let username = UserDefaults.username
        static let stylizedUsername = UserDefaults.stylizedUsername
    }
}

enum VotingType : String{
    case choose, vote
}
