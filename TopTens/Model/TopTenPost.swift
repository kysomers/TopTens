//
//  TopTenPost.swift
//  TopTens
//
//  Created by Kyle Somers on 7/20/17.
//  Copyright © 2017 Kyle Somers. All rights reserved.
//

import Foundation
import FirebaseDatabase

final class TopTenPost{
    
    var metadata : TopTenMetadata
    var listItems = [ListItem]()
    var allUsersForPost = [User]()
    

    init(listItems : [ListItem], metadata : TopTenMetadata){
        self.metadata = metadata
        self.listItems = listItems
       // self.allUsersForPost = uidStrings
    }
    

    
    

}
