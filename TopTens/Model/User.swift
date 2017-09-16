//
//  User.swift
//  TopTens
//
//  Created by Kyle Somers on 7/17/17.
//  Copyright © 2017 Kyle Somers. All rights reserved.
//

import Foundation
import FirebaseDatabase

final class User : NSObject {
    
    
    // 1
    private static var _current: User?
    
    // 2
    static var current: User {
        // 3
        guard let currentUser = _current else {
            fatalError("Error: current user doesn't exist")
        }
        
        // 4
        return currentUser
    }
    
    // MARK: - Class Methods
    
    // 5
    class func setCurrent(_ user: User, writeToUserDefaults: Bool = false) {
        // 2
        if writeToUserDefaults {
            // 3
            let data = NSKeyedArchiver.archivedData(withRootObject: user)
            
            // 4
            UserDefaults.standard.set(data, forKey: Constants.UserDefaults.currentUser)
        }
        
        _current = user
    }
    
    // MARK: - Properties
    
    let uid: String
    let username: String
    let stylizedUsername : String
    var canSeeRealName = true
    var fullName : String
    var friends = [User]()
    var sentRequests = [User]()
    var receivedRequests = [User]()
    
    
    // MARK: - Init
    
    init(uid: String, stylizedUsername: String, fullName : String) {
        self.uid = uid
        self.stylizedUsername = stylizedUsername
        self.username = stylizedUsername.lowercased()
        self.fullName = fullName
        super.init()
    }
    

    
    init?(dict : [String : Any], uid : String){
        guard let username = dict[Constants.UserDefaults.username] as? String,
            let stylizedUsername = dict[Constants.UserDefaults.stylizedUsername] as? String,
            let fullName = dict[Constants.UserDefaults.fullName] as? String

            else{
                return nil
            }

        self.username = username
        self.stylizedUsername = stylizedUsername
        self.uid = uid
        self.fullName = fullName
        
        super.init()
        
        self.friends = UserService.getUserArrayOutOfDict(userArray: dict[Constants.UserDefaults.friends])
        self.sentRequests = UserService.getUserArrayOutOfDict(userArray: dict[Constants.UserDefaults.sentRequests])
        self.receivedRequests = UserService.getUserArrayOutOfDict(userArray: dict[Constants.UserDefaults.receivedRequests])



    }
    
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let username = dict[Constants.UserDefaults.username] as? String,
            let stylizedUsername = dict[Constants.UserDefaults.stylizedUsername] as? String,
            let fullName = dict[Constants.UserDefaults.fullName] as? String
            
            else {
                
                return nil }
        
        self.uid = snapshot.key
        self.username = username
        self.stylizedUsername = stylizedUsername
        self.fullName = fullName
        super.init()
        
        self.friends = UserService.getUserArrayOutOfDict(userArray: dict[Constants.UserDefaults.friends])
        self.sentRequests = UserService.getUserArrayOutOfDict(userArray: dict[Constants.UserDefaults.sentRequests])
        self.receivedRequests = UserService.getUserArrayOutOfDict(userArray: dict[Constants.UserDefaults.receivedRequests])


        
    }

    

    //allows a user to be recreated from the user defaults
    required init?(coder aDecoder: NSCoder) {
        guard let uid = aDecoder.decodeObject(forKey: Constants.UserDefaults.uid) as? String,
            let username = aDecoder.decodeObject(forKey: Constants.UserDefaults.username) as? String,
            let stylizedUsername = aDecoder.decodeObject(forKey: Constants.UserDefaults.stylizedUsername) as? String,
            let fullName = aDecoder.decodeObject(forKey: Constants.UserDefaults.fullName) as? String

            else { return nil }
        
        self.uid = uid
        self.username = username
        self.stylizedUsername = stylizedUsername
        self.fullName = fullName
        
        super.init()
    }
    
    func toDictionary() -> [String : Any]{
        var myDict : [String : Any] = [:]
        myDict[Constants.UserDefaults.fullName] = self.fullName
        myDict[Constants.UserDefaults.username] = self.username
        myDict[Constants.UserDefaults.stylizedUsername] = self.stylizedUsername
        
        return myDict
    }
    
    
}

extension User: NSCoding {
    
    //This allows basic things about the user to be stored in NSUserDefaults
    func encode(with aCoder: NSCoder) {
        aCoder.encode(uid, forKey: Constants.UserDefaults.uid)
        aCoder.encode(username, forKey: Constants.UserDefaults.username)
        aCoder.encode(stylizedUsername, forKey: Constants.UserDefaults.stylizedUsername)
        aCoder.encode(fullName, forKey: Constants.UserDefaults.fullName)


    }
}


