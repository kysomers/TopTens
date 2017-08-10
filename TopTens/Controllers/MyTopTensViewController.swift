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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        TopTenPostService.fetchMetadataForUser(User.current, completion: {(topTenMetadatas) in
            self.myTopTens = topTenMetadatas
            print(self.myTopTens)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
            
            TopTenPostService.fetchListItems(from: metadata, completion: {(listItems) in
                
                if let listItems = listItems{
                    let sortedListItems = listItems.sorted(by: {$0.position < $1.position})
                    nextVC.topTenPost = TopTenPost(listItems: sortedListItems, metadata: metadata)
                }
                else{
                    nextVC.topTenPost = TopTenPost(listItems: [], metadata: metadata)
                }
            
            })
            
//            let ref = Database.database().reference().child(Constants.TopTenPost.key).child(metadata.creatorUID).child(metadata.uid)
//            ref.observe(.value, with: {(snapshot) in
//                
//                    
//            })

        }
    }


    
    @IBAction func addButtonTapped(_ sender: Any) {
        let setTitleAlert = UIAlertController(title: "What is the name of your new Top Ten List?", message: "", preferredStyle: .alert)
        
        setTitleAlert.addTextField(configurationHandler: {(newTextField) in
            newTextField.text = "Top 10 "
        
        })
        
        let saveButton = UIAlertAction(title: "Create", style: .default, handler: {(sender) in
        
            guard let textField = setTitleAlert.textFields?.first, let text = textField.text, text != "", text != "Top Ten "
                else{ return}
            
            TopTenPostService.create(title: text, completion: {(topTenPost) in
                guard let topTenPost = topTenPost
                    else{return}
                self.myTopTens.append(topTenPost)
            })
        
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        setTitleAlert.addAction(saveButton)
        setTitleAlert.addAction(cancelButton)
        
        self.present(setTitleAlert, animated: true, completion: nil)
        
    }

}

extension MyTopTensViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myTopTens.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "TopTenCell", for: indexPath)
        cell.textLabel?.text = myTopTens[indexPath.row].title
        
        
        
        return cell
    }
    
    
}
