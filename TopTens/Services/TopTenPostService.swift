//
//  TopTenPostService.swift
//  TopTens
//
//  Created by Kyle Somers on 7/22/17.
//  Copyright © 2017 Kyle Somers. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct TopTenPostService{
   
    static func create(title: String, completion: @escaping (TopTenMetadata?) -> Void) {

        
        let postAttrs = [Constants.TopTenPostMetadata.title: title,
                         Constants.TopTenPostMetadata.dateCreated: Date().timeIntervalSince1970,
                         Constants.TopTenPostMetadata.dateModified : Date().timeIntervalSince1970,
                         Constants.TopTenPostMetadata.ownerUID : User.current.uid,
                         Constants.TopTenPostMetadata.creatorUsername : User.current.username,
                         Constants.TopTenPostMetadata.isShared : false,
                         Constants.TopTenPostMetadata.votingType : VotingType.choose.rawValue] as [String : Any]
        
        
        
        
        
        let dummyRef = Database.database().reference().child("TopTenPostMetadata").child(User.current.uid).childByAutoId()
        let ref = Database.database().reference()
        let newUid = dummyRef.key
        
        var dictToWrite : [String : Any] = [:]
        
        dictToWrite["TopTenPostMetadata/\(User.current.uid)/\(newUid)"] = postAttrs
        dictToWrite["\(Constants.PostUsers.key)/\(newUid)/\(User.current.uid)"] = User.current.toDictionary()
    
        
        ref.updateChildValues(dictToWrite, withCompletionBlock:  { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            ref.child("TopTenPostMetadata").child(User.current.uid).child(newUid).observeSingleEvent(of: .value, with: { (snapshot) in
                let topTenMetadata = TopTenMetadata(snapshot: snapshot)
                completion(topTenMetadata)
            })
            
        })
        

    }
    
    
    
    static func addNewListItem(_ newListItem: ListItem, to topTenPost : TopTenPost, completion : @escaping (String?)->Void){
        
        let newUID = Database.database().reference().child(Constants.TopTenPost.key).child(topTenPost.metadata.uid).child(User.current.uid).childByAutoId().key
        
        print(newUID)
        var dictToWrite : [String : Any] = [:]
        dictToWrite["\(Constants.TopTenPost.key)/\(topTenPost.metadata.uid)/\(User.current.uid)/\(newUID)"] = newListItem.toDictionary()
        dictToWrite["\(Constants.TopTenShared.key)/\(topTenPost.metadata.uid)/\(newUID)"] = newListItem.toDictionaryForShared()
        let ref = Database.database().reference()
        ref.updateChildValues(dictToWrite, withCompletionBlock: {(error, ref) in
            
            if error == nil{
                completion(newUID)
            }
            else{
                completion(nil)
                print("WEEEOOOO WEEEOOO, error with adding a new list item")
            }
        
            
        
        })
        
    }
    
    
    static func addUsersToExistingTopTenPost(users : [User], topTenPost : TopTenPost, success : @escaping (Bool) -> Void){
        var dictToWrite : [String : Any] = [:]
        let ref = Database.database().reference()
        
        let postAttrs = [Constants.TopTenPostMetadata.title: topTenPost.metadata.title,
                         Constants.TopTenPostMetadata.dateCreated: topTenPost.metadata.dateCreated.timeIntervalSince1970,
                         Constants.TopTenPostMetadata.dateModified : Date().timeIntervalSince1970,
                         Constants.TopTenPostMetadata.ownerUID : topTenPost.metadata.ownerUID,
                         Constants.TopTenPostMetadata.creatorUsername : topTenPost.metadata.creatorUsername,
                         Constants.TopTenPostMetadata.isShared : false,
                         Constants.TopTenPostMetadata.votingType : VotingType.choose.rawValue] as [String : Any]
        
        for aUser in users{
            
            dictToWrite["\(Constants.TopTenPostMetadata.key)/\(aUser.uid)/\(topTenPost.metadata.uid)"] = postAttrs
            dictToWrite["\(Constants.PostUsers.key)/\(topTenPost.metadata.uid)/\(aUser.uid)"] = aUser.toDictionary()
            
            
            
            
        }
        
        ref.updateChildValues(dictToWrite, withCompletionBlock: {(error, ref) in
            
            if error != nil{
                print("failed to new users to this top ten list")
                success(false)
            }
            else{
                print("successfully added new users to this top ten list")
                success(true)
            }
            
        })
        
    }
    
    //This is normally used with changing positions
    static func updateListItemsForUser(listItems : [ListItem], metadata : TopTenMetadata){
        var newDictionary : [String : Any] = [:]
        
        for anItem in listItems{
            
            if let uid = anItem.uid{
                newDictionary[uid] = anItem.toDictionary()
            }
            else{
                print("Could not update list item on server since it didn't have a uid")
                continue
            }
        }
        var dictToWrite : [String : Any] = [:]
        dictToWrite["\(Constants.TopTenPost.key)/\(metadata.uid)/\(User.current.uid)"] = newDictionary
        let ref = Database.database().reference()
        ref.updateChildValues(dictToWrite, withCompletionBlock: {(error, ref) in
            if error != nil{
                print("Failed to update list items on server due to writing issue")
            }
            
            
        })
    }
    
    static func deleteListItemAndUpdateOthersForUser(deletedlistItem : ListItem, itemsToUpdate: [ListItem], metadata : TopTenMetadata, success : @escaping (Bool) -> Void){
        var dictToWrite : [String : Any] = [:]
        
        //Deletion stuff
        deletedlistItem.deleted = true
        
        let topTenPostPath = [Constants.TopTenPost.key, metadata.uid, User.current.uid, deletedlistItem.uid].toPath()
        let topTenSharedDeletedPath = [Constants.TopTenShared.key, metadata.uid, deletedlistItem.uid, Constants.TopTenShared.deleted].toPath()
        print(topTenPostPath)
        dictToWrite[topTenPostPath] = NSNull()
        dictToWrite[topTenSharedDeletedPath] = true
        
        //update the other items
        for anItem in itemsToUpdate{
            if let itemUID = anItem.uid{
                let itemPath = [Constants.TopTenPost.key, metadata.uid, User.current.uid, itemUID].toPath()
                dictToWrite[itemPath] =  anItem.toDictionary()
            }
        }
        
        let ref = Database.database().reference()
        ref.updateChildValues(dictToWrite, withCompletionBlock: {(error, ref) in
          
            if error == nil{
                success(true)
            }
            else{
                print("failed to delete a list item from the server")
                success(false)
            }
            
        })
        
        
        
    }
    
    static func checkIfListItemWasDeleted(listItem : ListItem, metadata : TopTenMetadata, result : @escaping (DeletedResult) -> Void){
        guard let listItemUid = listItem.uid else {return}
        let ref = Database.database().reference().child(Constants.TopTenShared.key).child(metadata.uid).child(listItemUid).child(Constants.TopTenShared.deleted)
        
        ref.observeSingleEvent(of: .value, with: {snapshot in
            print(snapshot.value)
            guard let isDeleted =  snapshot.value as? Bool else{result(.error); return}
            if isDeleted{
                result(.deleted)
            }
            else{
                result(.notDeleted)
            }
            
            
        })
    }
    
    static func updateSingleListItemUniversally(listItem : ListItem, metadata : TopTenMetadata, success : @escaping (Bool) -> Void){
        
        checkIfListItemWasDeleted(listItem: listItem, metadata: metadata, result: {deletedStatus in
        
            if deletedStatus == .error{
                success(false)
            }
            else if deletedStatus == .notDeleted{
                var dictToWrite : [String : Any] = [:]
                guard let listItemUid = listItem.uid,
                    listItemUid != ""
                    else {print("This list item doesn't have a UID") ; return}
                
                
                
                
                let topTenPostPath = [Constants.TopTenPost.key, metadata.uid, User.current.uid, listItemUid].toPath()
                let topTenSharedPath = [Constants.TopTenShared.key, metadata.uid, listItemUid].toPath()
                dictToWrite[topTenPostPath] = listItem.toDictionary()
                dictToWrite[topTenSharedPath] = listItem.toDictionaryForShared()
                
                let ref = Database.database().reference()
                ref.updateChildValues(dictToWrite, withCompletionBlock: {(error, ref) in
                    if error != nil{
                        print("There was an error updating the list item")
                        success(false)
                    }
                    else{
                        success(true)
                    }
                    
                })
            }
            else{
                //TODO: -  V2 Have the item be deleted from the user's stuff if they tried to mess with an item that was deleted
            }
        
        })
        
        
    }
    
    static func fetchListItemsAndUIDsForUser(user: User, from metadata : TopTenMetadata, completion : @escaping ([ListItem]) -> Void){
        
        var listItemArray = [ListItem]()
        let ref = Database.database().reference().child(Constants.TopTenPost.key).child(metadata.uid).child(user.uid)
        ref.observeSingleEvent(of: .value, with: {(snapshot) in


            if let listDictionary = snapshot.value as? [String : Any]{
                for (uid, singleListDictionary) in listDictionary{
                    if let singleListDictionary =  singleListDictionary as? [String : Any], let newListItem = ListItem(dict: singleListDictionary, uid : uid){
                        listItemArray.append(newListItem)
                        
                    }
                }
            }

            completion(listItemArray)
            
        
        })
        
        
    }
    
    static func fetchMetadataForUser(_ user : User, completion: @escaping ([TopTenMetadata]) -> Void){
        let ref = Database.database().reference().child(Constants.TopTenPostMetadata.key).child(user.uid)
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            guard let snapshots = snapshot.children.allObjects as? [DataSnapshot]
                else {
                    print("failed to download any top ten metadatas")
                    return completion([]) }
            
            //let dispatchGroup = DispatchGroup()
            
            var metadatas = [TopTenMetadata]()
            print(snapshots.count)
            for aSnapshot in snapshots {
                
                guard let newMetadata = TopTenMetadata(snapshot: aSnapshot)
                    else{continue}
                
                metadatas.append(newMetadata)

                

            }
            
            print("sucessfully downloaded top ten metadatas")
            completion(metadatas)
            
 
        
        
        })
    }
    
    static func fetchUsersForTopTenPostAndPostNotification(topTenPost : TopTenPost, completion : @escaping ([User]) -> Void){
        let ref = Database.database().reference().child(Constants.PostUsers.key).child(topTenPost.metadata.uid)
        ref.observe(.value, with: {(snapshot) in
            var returnedUsers = [User]()
            if let usersDict = snapshot.value as? [String : [String : Any]]{
                for (uid, userDict) in usersDict{
                    if let newUser = User(dict: userDict, uid: uid){
                        returnedUsers.append(newUser)
                    }
                    else{
                        print("Failed to cast user dictionary to user when fetching users for post")
                    }
                }
            }
            else{
                print("Failed to cast dictionary when fetching other users for post")
            }
            completion(returnedUsers)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.Notifications.fetchedUsersForPost), object: nil)

            //post notification
        
        })
    }
    
    
    
    
    
}
