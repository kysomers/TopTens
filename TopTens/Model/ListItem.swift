//
//  ListItem.swift
//  TopTens
//
//  Created by Kyle Somers on 7/20/17.
//  Copyright © 2017 Kyle Somers. All rights reserved.
//

import Foundation

final class ListItem{
    
    var title : String
    var votes : Int = 0
    var position : Int
    var isSortingManual : Bool
    var creatorUID : String
    var creatorUsername : String
    var dateCreated : Date
    var uid : String?

    
    //TODO: - Fix this shit (great comment, Past Kyle. Fix what?)
    init(title : String, user : User) {
        self.title = title
        self.position = 0
        self.isSortingManual = true
        self.dateCreated = Date()
        self.creatorUsername = user.username
        self.creatorUID = user.uid
        

        
    }
    
    init?(dict : [String : Any], uid : String){
        guard let title = dict[Constants.ListItem.title] as? String,
            let votes = dict[Constants.ListItem.votes] as? Int,
            let position = dict[Constants.ListItem.position] as? Int,
            let isSortingManual = dict[Constants.ListItem.isSortingManual] as? Bool,
            let creatorUID = dict[Constants.ListItem.creatorUID] as? String,
            let creatorUsername = dict[Constants.ListItem.creatorUsername] as? String,
            let dateCreated = dict[Constants.ListItem.dateCreated] as? TimeInterval
            

        
            else {
                print("Retrieved metadata dictionary insufficient to make new object")
                return nil }
        
        self.votes = votes
        self.position = position
        self.title = title
        self.isSortingManual = isSortingManual
        self.creatorUID = creatorUID
        self.creatorUsername = creatorUsername
        self.dateCreated = Date(timeIntervalSince1970: dateCreated)
        self.uid = uid
        
    }
    
    func toDictionary() -> [String: Any]{
        var myDict : [String : Any] = [:]
        myDict[Constants.ListItem.title] = self.title
        myDict[Constants.ListItem.position] = self.position
        myDict[Constants.ListItem.votes] = self.votes
        myDict[Constants.ListItem.isSortingManual] = self.isSortingManual
        myDict[Constants.ListItem.creatorUID] = self.creatorUID
        myDict[Constants.ListItem.creatorUsername] = self.creatorUsername
        myDict[Constants.ListItem.dateCreated] = self.dateCreated.timeIntervalSince1970

        return myDict
    }
    
}
