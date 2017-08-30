//
//  UserService.swift
//  TopTens
//
//  Created by Kyle Somers on 7/18/17.
//  Copyright © 2017 Kyle Somers. All rights reserved.
//

import Foundation
import FirebaseAuth.FIRUser
import FirebaseDatabase

struct UserService {
    
    static func show(forUID uid: String, completion: @escaping (User?) -> Void) {
        let ref = Database.database().reference().child(Constants.UserDefaults.key).child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let user = User(snapshot: snapshot) else {
                return completion(nil)
            }
            
            completion(user)
        })
    }
    
    static func changeCurrentUserFullname(to newName : String, succeeded : @escaping (Bool) -> Void){
        let ref = Database.database().reference().child(Constants.UserDefaults.key).child(User.current.uid).child(Constants.UserDefaults.fullName)
        ref.setValue(newName, withCompletionBlock : {(error, _) in
            if error != nil{
                print("Failed to update username")
                succeeded(false)
            }
            else{
                print("Successfully updated username")
                succeeded(true)
            }
        
        })
        
    }
    
    
    static func create(_ firUser: FIRUser, username: String, completion: @escaping (User?) -> Void) {
        let userAttrs = [Constants.UserDefaults.stylizedUsername: username, Constants.UserDefaults.username : username.lowercased(), Constants.UserDefaults.fullName : firUser.displayName]
        
        let ref = Database.database().reference().child(Constants.UserDefaults.key).child(firUser.uid)
        ref.setValue(userAttrs) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let user = User(snapshot: snapshot)
                completion(user)
            })
        }
    }
    
    static func getUserArrayOutOfDict(userArray : Any?) -> [User]{
        var array = [User]()
        guard let userArray = userArray as? [String : [String : Any]]
            else{
                return []
        }
        for (uid,aDict) in userArray{
            if let newUser = User(dict: aDict, uid: uid){
                array.append(newUser)
            }
        }
        
        return array
    }
    
    static func refreshSocialArraysForCurrentUser(){
        
        let friendsRef = Database.database().reference().child(Constants.UserDefaults.key).child(User.current.uid).child(Constants.UserDefaults.friends)
        friendsRef.observe(.value, with: {snapshot in
            let dict = snapshot.value
            User.current.friends = UserService.getUserArrayOutOfDict(userArray: dict)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.Notifications.refreshedSocialArray), object: nil)

            
        })
        let receivedRef = Database.database().reference().child(Constants.UserDefaults.key).child(User.current.uid).child(Constants.UserDefaults.receivedRequests)
        receivedRef.observe(.value, with: {snapshot in
            let dict = snapshot.value
            User.current.receivedRequests = UserService.getUserArrayOutOfDict(userArray: dict)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.Notifications.refreshedSocialArray), object: nil)

        })
        let sentRef = Database.database().reference().child(Constants.UserDefaults.key).child(User.current.uid).child(Constants.UserDefaults.sentRequests)
        sentRef.observe(.value, with: {snapshot in
            let dict = snapshot.value
            User.current.sentRequests = UserService.getUserArrayOutOfDict(userArray: dict)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.Notifications.refreshedSocialArray), object: nil)

        })
        
    }
    
    static func checkIfUsernameExists(username : String, exists : @escaping (Bool) -> Void){
        let lowercaseUsername = username.lowercased()
        let userRef = Database.database().reference().child(Constants.UserDefaults.key)
        
        userRef.queryOrdered(byChild: Constants.UserDefaults.username).queryEqual(toValue: lowercaseUsername).observeSingleEvent(of: .value, with: {snapshot in
            if snapshot.value is [String : Any]{
                exists(true)
            }
            else{
                exists(false)
            }
        })
        
    }
    
    
    
    
    
    
}
