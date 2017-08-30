//
//  SeeFriendsTopTensViewController.swift
//  TopTens
//
//  Created by Kyle Somers on 8/15/17.
//  Copyright © 2017 Kyle Somers. All rights reserved.
//

import UIKit

class SeeFriendsTopTensViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var titleText = "" //this gets set in prepare for segue because it doesn't have a load time like the list items
    var listItems = [ListItem]()
    var topTenPost : TopTenPost?{
        didSet{
            
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 122.0

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleLabel.text = titleText
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        guard let listItemDetailViewController = (segue.destination as? UINavigationController)?.viewControllers[0] as? ListItemDetailViewController,
            let topTenPost = topTenPost
            else{return}
        listItemDetailViewController.topTenListItem = sender as? ListItem
        listItemDetailViewController.topTenMetadata = topTenPost.metadata
 
    }
 

}

extension SeeFriendsTopTensViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let topTenPost = topTenPost else{return 0}
        listItems = topTenPost.listItems
            
        
        return listItems.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let curListItem = listItems[indexPath.row]
        if curListItem.detailsString != ""{
            self.performSegue(withIdentifier: Constants.Segues.toListItemDetailSegue, sender: topTenPost?.listItems[indexPath.row])
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Top Ten List Cell", for: indexPath) as! ListItemTableViewCell
        let curListItem = listItems[indexPath.row]
        cell.contentLabel.text = curListItem.title
        cell.contentLabel.preferredMaxLayoutWidth = cell.contentLabel.frame.size.width - 20;

        return cell
        
    }
}
