//
//  TopTenMetadata.swift
//  TopTens
//
//  Created by Kyle Somers on 7/22/17.
//  Copyright © 2017 Kyle Somers. All rights reserved.
//

import Foundation
import FirebaseDatabase

final class TopTenMetadata{
    
    var creatorUID : String
    var uid : String
    var title : String
    var dateCreated : Date
    var dateModified : Date
    var users = [User]()
    var votingType : String
    var creatorUsername : String
    //add genre

    

    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let title = dict[Constants.TopTenPostMetadata.title] as? String,
            let creatorUID = dict[Constants.TopTenPostMetadata.creatorUID] as? String,
            let dateCreated = dict[Constants.TopTenPostMetadata.dateCreated] as? TimeInterval,
            let dateModified = dict[Constants.TopTenPostMetadata.dateModified] as? TimeInterval,
            let votingType = dict[Constants.TopTenPostMetadata.votingType] as? String,
            let creatorUsername = dict[Constants.TopTenPostMetadata.creatorUsername] as? String


            else {
                print("Retrieved metadata dictionary insufficient to make new object")
                return nil }
        
        self.uid = snapshot.key
        self.title = title
        self.creatorUID = creatorUID
        self.dateCreated = Date(timeIntervalSince1970: dateCreated)
        self.dateModified = Date(timeIntervalSince1970: dateModified)
        self.votingType = votingType
        self.creatorUsername = creatorUsername
        
    }
    
}
