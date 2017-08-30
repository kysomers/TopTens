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
    

//    init(snapshot: DataSnapshot, metadata : TopTenMetadata) {
//        self.metadata = metadata
//
//        guard let dict = snapshot.value as? [String : Any]
//            else {
//                //There was nothing there, so this must be a new post
//                print("Making blank TopTenPost for supposed new item")
//                return }
//        
//        //get the existing list items
//        for (uid, value) in dict{
//            if let singleListItemDict = value as? [String : Any], let newListItem = ListItem(dict : singleListItemDict, uid : uid){
//                
//                listItems.append(newListItem)
//                
//            }
//            else{
//                continue
//            }
//        }
//        listItems.sort(by: {(item1, item2) in item1.position > item2.position})
//        
//        
//    }
    
    

}
