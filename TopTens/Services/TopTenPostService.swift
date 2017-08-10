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
                         Constants.TopTenPostMetadata.creatorUID : User.current.uid,
                         Constants.TopTenPostMetadata.creatorUsername : User.current.username,
                         Constants.TopTenPostMetadata.votingType : VotingType.choose.rawValue] as [String : Any]
        
        
        let metaRef = Database.database().reference().child("TopTenPostMetadata").child(User.current.uid).childByAutoId()
        metaRef.setValue(postAttrs) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let topTenMetadata = TopTenMetadata(snapshot: snapshot)
                completion(topTenMetadata)
            })
 
        }
        
        
        
        
        
    }
    
    
    
    static func addNewListItem(_ newListItem: ListItem, to topTenPost : TopTenPost, completion : @escaping (DatabaseReference?)->Void){
        
        let ref = Database.database().reference().child(Constants.TopTenPost.key).child(topTenPost.metadata.uid).childByAutoId()
        ref.setValue(newListItem.toDictionary(), withCompletionBlock: {(error, ref) in
            
            if error == nil{
                completion(ref)
            }
            else{
                completion(nil)
            }
        
            
        
        })
        
    }
    
    static func updateListItems(listItems : [ListItem], metadata : TopTenMetadata){
        for anItem in listItems{
            var ref = Database.database().reference().child(Constants.TopTenPost.key).child(metadata.uid)
            if let uid = anItem.uid{
                ref = ref.child(uid)
            }
            else{
                print("Could not update list item on server since it didn't have a uid")
                
            }
            
            ref.updateChildValues(anItem.toDictionary(), withCompletionBlock: {(error, ref) in
                if error != nil{
                    print("Failed to update list item on server due to writing issue")
                }
                
            
            })
        }
    }
    
    static func fetchListItems(from metadata : TopTenMetadata, completion : @escaping ([ListItem]?) -> Void){
        
        var listItemArray = [ListItem]()
        let ref = Database.database().reference().child(Constants.TopTenPost.key).child(metadata.uid)
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            guard let listDictionary = snapshot.value as? [String : Any]
                else{
                    completion(nil)
                    return}
            
            for (uid, singleListDictionary) in listDictionary{
                if let singleListDictionary =  singleListDictionary as? [String : Any], let newListItem = ListItem(dict: singleListDictionary, uid : uid){
                    listItemArray.append(newListItem)

                }
            }
            completion(listItemArray)
            
        
        })
        
        
    }
    
    static func fetchMetadataForUser(_ user : User, completion: @escaping ([TopTenMetadata]) -> Void){
        let ref = Database.database().reference().child(Constants.TopTenPostMetadata.key).child(user.uid)
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            guard let snapshots = snapshot.children.allObjects as? [DataSnapshot]
                else { return completion([]) }
            
            let dispatchGroup = DispatchGroup()
            
            var metadatas = [TopTenMetadata]()
            print(snapshots.count)
            for aSnapshot in snapshots {
                
                guard let newMetadata = TopTenMetadata(snapshot: aSnapshot)
                    else{return}
                
                metadatas.append(newMetadata)

                

            }
            
            completion(metadatas)
            
 
        
        
        })
    }
    
}
