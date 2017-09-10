//
//  DisplayTopTenViewController.swift
//  TopTens
//
//  Created by Kyle Somers on 7/24/17.
//  Copyright © 2017 Kyle Somers. All rights reserved.
//

import UIKit

class DisplayTopTenViewController: UIViewController{

    var rereloaded = false
    var topTenMetadata : TopTenMetadata?
    
    var xImage = UIImage(named: "XICon.png")?.withRenderingMode(.alwaysTemplate)
    var checkboxImage = UIImage(named: "icons8-Checkmark-100.png")?.withRenderingMode(.alwaysTemplate)
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var addFriendsButton: UIButton!
    @IBOutlet weak var seeFriendsListsButtons: UIButton!
    @IBOutlet weak var addNewButton: UIButton!
    
    let setTitleAlert = UIAlertController(title: "Add something to this top ten list.", message: "", preferredStyle: .alert)
    
    let tooManyCharactersAlert = UIAlertController(title: "That's too long!", message: "If you'd like you can add a description later, but there's a max character count of 100.", preferredStyle: .alert)
    
    
    var topTenPost : TopTenPost?{
        didSet{
            tableView.reloadData()

            print("top ten post was updated")
        }
    }
    var topTenCount = 10
    
    
    //@IBOutlet weak var sortSegmentedControl: UISegmentedControl!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
       // sortSegmentedControl.tintColor = UIColor.appPurple
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 122.0
        
        
        //self.isEditing = true
        
        tableView.isEditing = true
        
        setupActionControllers()
        
        deleteButton.setImage(deleteButton.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
        deleteButton.setImage(deleteButton.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .highlighted)
        deleteButton.imageView?.tintColor = .appPurple
        
        addFriendsButton.setImage(addFriendsButton.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
        addFriendsButton.setImage(addFriendsButton.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .highlighted)
        addFriendsButton.imageView?.tintColor = .appPurple
        
        seeFriendsListsButtons.setImage(seeFriendsListsButtons.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
        seeFriendsListsButtons.setImage(seeFriendsListsButtons.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .highlighted)
        seeFriendsListsButtons.imageView?.tintColor = .appPurple
        
        addNewButton.setImage(addNewButton.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
        addNewButton.setImage(addNewButton.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .highlighted)
        addNewButton.imageView?.tintColor = .appPurple
        
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        titleLabel.text = topTenMetadata?.title
        if let topTenMetadata = topTenMetadata{
            topTenCount = numberOfItemsFromTitle(title: topTenMetadata.title)
            
        }
        
    }
    
    func turnOffDeleteMode(){
        deleteButton.setImage(xImage, for: .normal)
        isEditing = false
        tableView.reloadData()
    }
    
    func numberOfItemsFromTitle(title : String) -> Int{
        let wordArray = title.toWordArray()
        if wordArray.count < 2{
            return 10
        }
        else if wordArray[0] != "Top"{
            return 10
        }
        else if let number =  Int(wordArray[1]), number > 0, number <= 500{
            return number
        }
        else{
            return 10
        }
    }
    
 
    
    func setupActionControllers(){
        
        
        
        setTitleAlert.addTextField(configurationHandler: nil)
        
        
        let saveButton = UIAlertAction(title: "Add", style: .default, handler: {(sender) in
            
            guard let textField = self.setTitleAlert.textFields?.first, let text = textField.text, text != "", let topTenPost = self.topTenPost
                else{ return}
            
            if text.characters.count > 100{
                
                self.present(self.tooManyCharactersAlert, animated: true, completion: nil)
                
                return
                
            }
            
            textField.text = ""
            
            let newListItem = ListItem(title: text, user: User.current)
            
            //TODO: - If two people create things at the exact same time, they'll have the same position
            newListItem.position = topTenPost.listItems.count + 1
                
            

            TopTenPostService.addNewListItem(newListItem, to: topTenPost, completion: {(key) in
                guard let key = key
                    else{return}
                
                newListItem.uid = key
                topTenPost.listItems.append(newListItem)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }

                
            })
            
            
            
        })
        
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        
        setTitleAlert.addAction(saveButton)
        setTitleAlert.addAction(cancelButton)
        
        let okButton = UIAlertAction(title: "OK", style: .default, handler: {sender in
            
            
            self.present(self.setTitleAlert, animated: true, completion: nil)
            
            
        })

        
        tooManyCharactersAlert.addAction(okButton)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        turnOffDeleteMode()
        
        if segue.identifier == Constants.Segues.toListItemDetailSegue{
            let listItemDetailViewController = (segue.destination as! UINavigationController).viewControllers[0] as! ListItemDetailViewController
            listItemDetailViewController.topTenListItem = sender as? ListItem
            listItemDetailViewController.topTenMetadata = topTenMetadata
        }
        else if segue.identifier == Constants.Segues.toAddFriendsTableViewControllerSegue{
            let addFriendsTableViewController = (segue.destination as! UINavigationController).viewControllers[0] as! AddFriendsToTopTenTableViewController
            addFriendsTableViewController.topTenPost = self.topTenPost
        }
        else if segue.identifier == Constants.Segues.toSeeFriendsTopTenTableViewControllerSegue{
            let seeFriendsTopTenTableViewController = segue.destination as! SeeFriendsTopTenTableViewController
            seeFriendsTopTenTableViewController.topTenPost = self.topTenPost
        }
    }
    

    


    @IBAction func addButtonTapped(_ sender: Any) {
        
        turnOffDeleteMode()
        self.present(setTitleAlert, animated: true, completion: nil)
        
        
    }
    @IBAction func deleteButtonTapped(_ sender: Any) {
        if isEditing{
            deleteButton.setImage(xImage, for: .normal)


        }
        else{
            deleteButton.setImage(checkboxImage, for: .normal)


        }
        isEditing = !isEditing
        tableView.reloadData()
        
        
    }



}











extension DisplayTopTenViewController :  UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if topTenPost?.listItems[indexPath.row].ownerUID == User.current.uid{
            return true

        }
        return false
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let topTenPost = topTenPost else{return}
            let listItemToDelete = topTenPost.listItems[indexPath.row]
            var listItemsToUpdate = [ListItem]()
            for index in indexPath.row + 1 ..< topTenPost.listItems.count{
                //TODO: Make an array called listItemsToDisplay, since this is going to change the actual list items before
                //the callback when you'll be sure that you want them changed
                let curListItem = topTenPost.listItems[index]
                curListItem.position -= 1
                listItemsToUpdate.append(curListItem)
            }
            
            TopTenPostService.deleteListItemAndUpdateOthersForUser(deletedlistItem: listItemToDelete, itemsToUpdate: listItemsToUpdate, metadata: topTenPost.metadata, success: {success in
                TopTenPostService.fetchListItemsAndUIDsForUser(user: User.current, from: topTenPost.metadata, completion: {listItems in
                    DispatchQueue.main.async {
                        self.topTenPost?.listItems = listItems.sorted(by: {$0.position < $1.position})
                        
                        self.tableView.reloadData()
                    }
                
                })
            
            })
            

        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if let count = topTenPost?.listItems.count{
            return count
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.topTenListCell, for: indexPath) as! ListItemTableViewCell
        if let currentListItem = topTenPost?.listItems[indexPath.row]{
            cell.contentLabel.text = currentListItem.title
            //cell.userLabel.text = currentListItem.creatorUsername
            cell.numberLabel.text = String(currentListItem.position)
            cell.moreIndicatorView.isHidden = currentListItem.detailsString == ""
            cell.contentLabel.preferredMaxLayoutWidth = cell.contentLabel.frame.size.width - 20;
            
            colorCellForIndexPath(cell: cell, indexPath: indexPath, totalNumberOfCells: tableView.numberOfRows(inSection: 0))
            


        }

        
        return cell

    }
    
    func colorCellForIndexPath(cell : ListItemTableViewCell,indexPath : IndexPath, totalNumberOfCells : Int){
        
        if indexPath.row < topTenCount{
            cell.numberLabel.textColor = .appPurple
        }
        else{
            cell.numberLabel.textColor = .black

        }
        

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
        turnOffDeleteMode()
        
        
        TopTenPostService.updateListItemsForUser(listItems: topTenPost.listItems, metadata: topTenPost.metadata)
        
        
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let curListItem = topTenPost?.listItems[indexPath.row]
        if curListItem?.detailsString != "" || curListItem?.ownerUID == User.current.uid{
            self.performSegue(withIdentifier: Constants.Segues.toListItemDetailSegue, sender: topTenPost?.listItems[indexPath.row])
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if isEditing{
            return .delete

        }
        else{
            return .none
        }
        
    }
    
    
    
    

}
