//
//  UsernameViewController.swift
//  TopTens
//
//  Created by Kyle Somers on 7/18/17.
//  Copyright © 2017 Kyle Somers. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class UsernameViewController: UIViewController {

    @IBOutlet weak var takenUsernameWarningLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        
        UserService.checkIfUsernameExists(username: usernameTextField.text!, exists: {exists in
            if exists{
                self.showUsernameErrorWithMessage(message: "That username has already been taken.")

            }
            else{
                guard let currentUser = Auth.auth().currentUser, let username = self.usernameTextField.text else {return}
                if username.isEmpty{
                    self.showUsernameErrorWithMessage(message: "You gotta type something there, buddy.")



                }
                else if !username.containsOnlyLettersAndNumbers(){
                    self.showUsernameErrorWithMessage(message: "Your username can only contain numbers and letters.")


                }
                else if username.characters.count > 20{
                    self.showUsernameErrorWithMessage(message: "Your username can only have 20 characters max.")
                }
                else{
                    UserService.create(currentUser, username: username, completion: {(user) in
                        guard let user = user else { return }
                        User.setCurrent(user)
                        let storyboard = UIStoryboard(name: "Main", bundle: .main)
                        
                        if let initialViewController = storyboard.instantiateInitialViewController() {
                            self.view.window?.rootViewController = initialViewController
                            self.view.window?.makeKeyAndVisible()
                        }
                        
                    })
                }
                
                
                
            }
        
        })
        
        
        

        
        
    }
    
    func showUsernameErrorWithMessage(message : String){
        self.takenUsernameWarningLabel.isHidden = false
        self.takenUsernameWarningLabel.text = message
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
