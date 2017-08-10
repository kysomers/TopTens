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
        let ref = Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let user = User(snapshot: snapshot) else {
                return completion(nil)
            }
            
            completion(user)
        })
    }
    
    
    static func create(_ firUser: FIRUser, username: String, completion: @escaping (User?) -> Void) {
        let userAttrs = ["stylizedUsername": username, "username" : username.lowercased(), "fullName" : firUser.displayName]
        
        let ref = Database.database().reference().child("users").child(firUser.uid)
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
        
        let friendsRef = Database.database().reference().child("users").child(User.current.uid).child("friends")
        friendsRef.observe(.value, with: {snapshot in
            let dict = snapshot.value
            User.current.friends = UserService.getUserArrayOutOfDict(userArray: dict)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.Notifications.refreshedSocialArray), object: nil)

            
        })
        let receivedRef = Database.database().reference().child("users").child(User.current.uid).child("receivedRequests")
        receivedRef.observe(.value, with: {snapshot in
            let dict = snapshot.value
            User.current.receivedRequests = UserService.getUserArrayOutOfDict(userArray: dict)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.Notifications.refreshedSocialArray), object: nil)

        })
        let sentRef = Database.database().reference().child("users").child(User.current.uid).child("sentRequests")
        sentRef.observe(.value, with: {snapshot in
            let dict = snapshot.value
            User.current.sentRequests = UserService.getUserArrayOutOfDict(userArray: dict)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.Notifications.refreshedSocialArray), object: nil)

        })
        
        //I'd like to handle this with a post to notification center
    }
    
    
    
    
    
    
}
