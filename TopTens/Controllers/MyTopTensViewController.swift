//
//  MyTopTensViewController.swift
//  TopTens
//
//  Created by Kyle Somers on 7/20/17.
//  Copyright © 2017 Kyle Somers. All rights reserved.
//

import UIKit
import Firebase

class MyTopTensViewController: UIViewController {
    
    var myTopTens : [TopTenMetadata] = []{
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    
    @IBOutlet weak var tableView: UITableView!
    let refreshControl = UIRefreshControl()
    
    let setTitleAlert = UIAlertController(title: "What is the name of your new Top 10 List?", message: "", preferredStyle: .alert)

    let tooManyCharactersAlert = UIAlertController(title: "That's too long!", message: "Keep it less than 120 characters.", preferredStyle: .alert)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.appPurple
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupActionControllers()
        
        
        
        refreshControl.addTarget(self, action: #selector(reloadTopTens), for: .valueChanged)
        tableView.addSubview(refreshControl)

    }
    
    func reloadTopTens() {

        
        TopTenPostService.fetchMetadataForUser(User.current, completion: {(topTenMetadatas) in
            self.myTopTens = topTenMetadatas
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        TopTenPostService.fetchMetadataForUser(User.current, completion: {(topTenMetadatas) in
            self.myTopTens = topTenMetadatas
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        
        if let indexPath = tableView.indexPathForSelectedRow{
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! DisplayTopTenViewController
        if let row = tableView.indexPathForSelectedRow?.row{
            let metadata = myTopTens[row]
            nextVC.topTenMetadata = metadata
            
            TopTenPostService.fetchListItemsAndUIDsForUser(user: User.current, from: metadata, completion: {(listItems) in
                
                let sortedListItems = listItems.sorted(by: {$0.position < $1.position})
                let newPost = TopTenPost(listItems: sortedListItems, metadata: metadata)
                nextVC.topTenPost = newPost
                
                TopTenPostService.fetchUsersForTopTenPostAndPostNotification(topTenPost: newPost, completion: {(users) in
                    newPost.allUsersForPost = users
                
                })
                
               
            
            })
            
//            let ref = Database.database().reference().child(Constants.TopTenPost.key).child(metadata.ownerUID).child(metadata.uid)
//            ref.observe(.value, with: {(snapshot) in
//                
//                    
//            })

        }
    }

    func setupActionControllers(){
        
        
        
        setTitleAlert.addTextField(configurationHandler: nil)
        
        
        let saveButton = UIAlertAction(title: "Add", style: .default, handler: {(sender) in
            
            guard let textField = self.setTitleAlert.textFields?.first, let text = textField.text, text != ""
                else{ return}
            
            if text.characters.count > 120{
                
                self.present(self.tooManyCharactersAlert, animated: true, completion: nil)
                
                return
                
            }
            
            
            
            TopTenPostService.create(title: text, completion: {(topTenPost) in
                guard let topTenPost = topTenPost
                    else{return}
                self.myTopTens.append(topTenPost)
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


    
    @IBAction func addButtonTapped(_ sender: Any) {
        
        
        setTitleAlert.textFields?[0].text = "Top 10"
        
        self.present(setTitleAlert, animated: true, completion: nil)
        
    }

}

extension MyTopTensViewController : UITableViewDelegate, UITableViewDataSource{
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if myTopTens.count == 0 {
            return 1
        }
        return myTopTens.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if myTopTens.count == 0{
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "EmptyTableViewCell", for: indexPath)
            return cell
        }
        else{
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "TopTenCell", for: indexPath) as! MyTopTensTableViewCell
            
            let currentTopTen = myTopTens[indexPath.row]
            cell.titleLabel.text = currentTopTen.title
            
            if currentTopTen.ownerUID != User.current.uid{
                cell.dateCreatedLabel.text = "Created by " + currentTopTen.creatorUsername
                
            }
            else{
                cell.dateCreatedLabel.text = "Created on " + currentTopTen.dateCreated.toString()
                
            }
            
            
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if myTopTens.count == 0{
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
    
    
}
