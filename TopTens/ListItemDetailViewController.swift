//
//  ListItemDetailViewController.swift
//  TopTens
//
//  Created by Kyle Somers on 8/15/17.
//  Copyright © 2017 Kyle Somers. All rights reserved.
//

import UIKit

class ListItemDetailViewController: UIViewController {
    
    var topTenMetadata : TopTenMetadata?
    var topTenListItem : ListItem?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionTextView.layer.cornerRadius = 5
        descriptionTextView.clipsToBounds = true
        
        descriptionTextView.layer.borderColor = UIColor.gray.cgColor
        descriptionTextView.layer.borderWidth = 1
        

        // Do any additional setup after loading the view.
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        titleLabel.text = topTenListItem?.title
        descriptionTextView.text = topTenListItem?.detailsString
        descriptionTextView.isEditable = topTenListItem?.ownerUID == User.current.uid

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func doneButtonTapped(_ sender: Any) {
        
        if topTenListItem?.ownerUID == User.current.uid{
            self.topTenListItem?.detailsString = self.descriptionTextView.text
            TopTenPostService.updateSingleListItemUniversally(listItem: self.topTenListItem!, metadata: self.topTenMetadata!, success: {(succeeded) in
                print(succeeded)
                
            })
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
