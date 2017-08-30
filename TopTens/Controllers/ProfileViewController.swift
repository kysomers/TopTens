//
//  ProfileViewController.swift
//  TopTens
//
//  Created by Kyle Somers on 8/7/17.
//  Copyright © 2017 Kyle Somers. All rights reserved.
//

import UIKit
import  FirebaseAuth

class ProfileViewController: UIViewController {

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var logOutButton: UIButton!
    
    @IBOutlet weak var editNameButton: UIButton!
    @IBOutlet weak var editNameTextField: UITextField!
    @IBOutlet weak var usernameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fullNameLabel.text = User.current.fullName
        usernameLabel.text = User.current.username
       
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        if let text = editNameTextField.text, text != ""{
            UserService.changeCurrentUserFullname(to: text, succeeded: {succeeded in
            
                if succeeded{
                    User.current.fullName = text
                    User.setCurrent(User.current)
                    DispatchQueue.main.async {
                        self.fullNameLabel.text = text
                    }
                }
            
            })
            editNameButton.isHidden = false
            logOutButton.isHidden = false
            editNameTextField.isHidden = true
            doneButton.isHidden = true
            editNameTextField.resignFirstResponder()
            
            
        }
    }
    @IBAction func editNameTapped(_ sender: Any) {
        editNameButton.isHidden = true
        logOutButton.isHidden = true
        editNameTextField.isHidden = false
        doneButton.isHidden = false
        editNameTextField.text = User.current.fullName
        
    }
    @IBAction func logOutTapped(_ sender: Any) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let signOutAction = UIAlertAction(title: "Sign Out", style: .default) { _ in
            do {
                try Auth.auth().signOut()
            } catch let error as NSError {
                assertionFailure("Error signing out: \(error.localizedDescription)")
            }
            let appDomain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
            
            let loginViewController = UIStoryboard.initialViewController(for: "Login")
            self.view.window?.rootViewController = loginViewController
            self.view.window?.makeKeyAndVisible()
        }
        alertController.addAction(signOutAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
        
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

