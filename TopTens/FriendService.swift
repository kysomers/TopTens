//
//  FriendService.swift
//  TopTens
//
//  Created by Kyle Somers on 8/9/17.
//  Copyright © 2017 Kyle Somers. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct FriendService{
    
    
    static func sendRequestFromCurrentUser(toUser userThatRequestWasSentTo : User, succeeded : @escaping (Bool)->Void ){
        
        //should first check if they are in either friends list of if they are in the sent arrays already
        
        let ref = Database.database().reference()

        // Create the data we want to update
        var updatedUserData : [String : Any] = [:]
        updatedUserData["users/\(User.current.uid)/sentRequests/\(userThatRequestWasSentTo.uid)"] = userThatRequestWasSentTo.toDictionary()
        updatedUserData["users/\(userThatRequestWasSentTo.uid)/receivedRequests/\(User.current.uid)"] = User.current.toDictionary()

        // Do a deep-path update
        ref.updateChildValues(updatedUserData, withCompletionBlock: { (error, ref)  in
            if let error = error {
                print("Error updating data: \(error.localizedDescription)")
                succeeded(false)
            }
            else{
                succeeded(true)
            }
        })
    
        

    }
    
    
    static func confirmFriend(addedFriend : User, succeeded : @escaping (Bool)->Void ){
        
        //should first check if they are in either friends list of if they are in the sent arrays already
        
        let ref = Database.database().reference()
        
        // Create the data we want to update
        var updatedUserData : [String : Any] = [:]
        updatedUserData["users/\(User.current.uid)/sentRequests/\(addedFriend.uid)"] = [:]
        updatedUserData["users/\(addedFriend.uid)/receivedRequests/\(User.current.uid)"] = [:]
        updatedUserData["users/\(User.current.uid)/receivedRequests/\(addedFriend.uid)"] = [:]
        updatedUserData["users/\(addedFriend.uid)/sentRequests/\(User.current.uid)"] = [:]
        updatedUserData["users/\(addedFriend.uid)/friends/\(User.current.uid)"] = User.current.toDictionary()
        updatedUserData["users/\(User.current.uid)/friends/\(addedFriend.uid)"] = addedFriend.toDictionary()

        
        // Do a deep-path update
        ref.updateChildValues(updatedUserData, withCompletionBlock: { (error, ref)  in
            if let error = error {
                print("Error updating data: \(error.localizedDescription)")
                succeeded(false)
            }
            else{
                succeeded(true)
            }
        })
    }
    
    static func declinePerson(declinedPerson : User, succeeded : @escaping (Bool)->Void ){
        
        //should first check if they are in either friends list of if they are in the sent arrays already
        
        let ref = Database.database().reference()
        
        // Create the data we want to update
        var updatedUserData : [String : Any] = [:]
        updatedUserData["users/\(User.current.uid)/sentRequests/\(declinedPerson.uid)"] = [:]
        updatedUserData["users/\(declinedPerson.uid)/receivedRequests/\(User.current.uid)"] = [:]
        updatedUserData["users/\(User.current.uid)/receivedRequests/\(declinedPerson.uid)"] = [:]
        updatedUserData["users/\(declinedPerson.uid)/sentRequests/\(User.current.uid)"] = [:]

        
        
        // Do a deep-path update
        ref.updateChildValues(updatedUserData, withCompletionBlock: { (error, ref)  in
            if let error = error {
                print("Error updating data: \(error.localizedDescription)")
                succeeded(false)
            }
            else{
                succeeded(true)
            }
        })
    }
    
    
}
