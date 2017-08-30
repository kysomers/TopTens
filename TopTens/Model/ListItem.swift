//
//  ListItem.swift
//  TopTens
//
//  Created by Kyle Somers on 7/20/17.
//  Copyright © 2017 Kyle Somers. All rights reserved.
//

import Foundation

class ListItem{
    
    var title : String
    var position : Int
    var ownerUID : String
    var creatorUsername : String
    var dateCreated : Date
    var detailsString : String
    var uid : String?
    var deleted : Bool = false

    
    //TODO: - Fix this shit (great comment, Past Kyle. Fix what?)
    init(title : String, user : User) {
        self.title = title
        self.position = 0
        self.dateCreated = Date()
        self.creatorUsername = user.username
        self.ownerUID = user.uid
        self.detailsString = ""
        
        

        
    }
    
    init?(dict : [String : Any], uid : String){
        guard let title = dict[Constants.ListItem.title] as? String,
            let position = dict[Constants.ListItem.position] as? Int,
            let ownerUID = dict[Constants.ListItem.ownerUID] as? String,
            let creatorUsername = dict[Constants.ListItem.creatorUsername] as? String,
            let dateCreated = dict[Constants.ListItem.dateCreated] as? TimeInterval,
            let detailsString = dict[Constants.ListItem.detailsString] as? String
            

            

        
            else {
                print("Retrieved metadata dictionary insufficient to make new object")
                return nil }
        
        self.position = position
        self.title = title
        self.ownerUID = ownerUID
        self.creatorUsername = creatorUsername
        self.dateCreated = Date(timeIntervalSince1970: dateCreated)
        self.uid = uid
        self.detailsString = detailsString
        
    }
    
    func toDictionary() -> [String: Any]{
        var myDict : [String : Any] = [:]
        myDict[Constants.ListItem.title] = self.title
        myDict[Constants.ListItem.position] = self.position
        myDict[Constants.ListItem.ownerUID] = self.ownerUID
        myDict[Constants.ListItem.creatorUsername] = self.creatorUsername
        myDict[Constants.ListItem.dateCreated] = self.dateCreated.timeIntervalSince1970
        myDict[Constants.ListItem.detailsString] = self.detailsString

        return myDict
    }
    func toDictionaryForShared() -> [String: Any]{
        var myDict : [String : Any] = [:]
        myDict[Constants.ListItem.title] = self.title
        myDict[Constants.ListItem.ownerUID] = self.ownerUID
        myDict[Constants.ListItem.creatorUsername] = self.creatorUsername
        myDict[Constants.ListItem.dateCreated] = self.dateCreated.timeIntervalSince1970
        myDict[Constants.ListItem.detailsString] = self.detailsString
        myDict[Constants.TopTenShared.deleted] = self.deleted
        
        return myDict
    }
    
}
