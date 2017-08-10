//
//  DisplayTopTenViewController.swift
//  TopTens
//
//  Created by Kyle Somers on 7/24/17.
//  Copyright © 2017 Kyle Somers. All rights reserved.
//

import UIKit

class DisplayTopTenViewController: UIViewController{

    
    var topTenMetadata : TopTenMetadata?
    var topTenPost : TopTenPost?{
        didSet{
            tableView.reloadData()
            print("top ten post was updated")
        }
    }
    @IBOutlet weak var sortSegmentedControl: UISegmentedControl!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        titleLabel.text = topTenMetadata?.title
        sortSegmentedControl.tintColor = UIColor.appPurple
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 122.0
        
        tableView.allowsSelection = false
        
        //self.isEditing = true
        
        tableView.isEditing = true
        

        // Do any additional setup after loading the view.
    }
    

    


    @IBAction func addButtonTapped(_ sender: Any) {
        let setTitleAlert = UIAlertController(title: "Add something to this top ten list.", message: "", preferredStyle: .alert)
        
        setTitleAlert.addTextField(configurationHandler: nil)
        
        let saveButton = UIAlertAction(title: "Add", style: .default, handler: {(sender) in
            
            guard let textField = setTitleAlert.textFields?.first, let text = textField.text, text != "", text != "Top 10 "
                else{ return}
            var newListItem = ListItem(title: text, user: User.current)
            
            //TODO: - If two people create things at the exact same time, they'll have the same position
            if let count = self.topTenPost?.listItems.count{
                newListItem.position = count + 1

            }
            else{
                newListItem.position = 1

            }
            self.topTenPost?.listItems.append(newListItem)
            TopTenPostService.addNewListItem(newListItem, to: self.topTenPost!, completion: {(ref) in
                guard let ref = ref
                    else{return}
                
                newListItem.uid = ref.key
            
            })
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }

            
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        setTitleAlert.addAction(saveButton)
        setTitleAlert.addAction(cancelButton)
        
        self.present(setTitleAlert, animated: true, completion: nil)
        
        
    }


}

extension DisplayTopTenViewController :  UITableViewDelegate, UITableViewDataSource {

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if let count = topTenPost?.listItems.count{
            return count
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.topTenListCell, for: indexPath) as! EditListItemTableViewCell
        if let currentListItem = topTenPost?.listItems[indexPath.row]{
            cell.contentLabel.text = currentListItem.title
            cell.userLabel.text = currentListItem.creatorUsername
            cell.numberLabel.text = String(currentListItem.position)
        }
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let topTenPost = topTenPost
            else{return}
        let itemToMove = topTenPost.listItems[sourceIndexPath.row]
        topTenPost.listItems.remove(at: sourceIndexPath.row)
        topTenPost.listItems.insert(itemToMove, at: destinationIndexPath.row)
        
        for index in 0...topTenPost.listItems.count - 1{
            topTenPost.listItems[index].position = index + 1
        }
        tableView.reloadData()
        
        
        TopTenPostService.updateListItems(listItems: topTenPost.listItems, metadata: topTenPost.metadata)
        
        
        
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    

}
