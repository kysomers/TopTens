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

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var movingView: UIView!
    @IBOutlet weak var takenUsernameWarningLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
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
                else if username.characters.count < 6{
                    self.showUsernameErrorWithMessage(message: "Your username must have at least 6 characters.")
                }
                else{
                    UserService.create(currentUser, username: username, completion: {(user) in
                        guard let user = user else { return }
                        User.setCurrent(user, writeToUserDefaults: true)
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



}

extension UsernameViewController : UIGestureRecognizerDelegate {
    
    
    
    func handleTap(_ gestureRecognizer : UIGestureRecognizer){
        
        usernameTextField.resignFirstResponder()
        self.scrollView.setContentOffset(CGPoint(x:0, y:0), animated: true)

        
    }
    @IBAction func takeDownTheKeyboard(_ sender: Any) {
        print("keyboard retired")
        self.scrollView.setContentOffset(CGPoint(x:0, y:0), animated: true)

    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        
        guard let usernameRect = usernameTextField.superview?.convert(usernameTextField.frame, to: movingView) else{print("weird error"); return}
        
        if let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            
            if self.view.frame.height - keyboardFrame.height < usernameRect.maxY {
                
                

                self.scrollView.setContentOffset(CGPoint(x: 0, y:  usernameRect.origin.y - 60), animated: true)
            }
        }
        // do stuff with the frame...
    }
    
}
