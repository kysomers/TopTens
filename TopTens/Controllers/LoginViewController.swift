//
//  LoginViewController.swift
//  TopTens
//
//  Created by Kyle Somers on 7/16/17.
//  Copyright © 2017 Kyle Somers. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseAuthUI
import FirebaseDatabase
import FirebaseFacebookAuthUI
import FirebaseGoogleAuthUI
import FBSDKLoginKit

typealias FIRUser = FirebaseAuth.User

class LoginViewController: UIViewController {

    @IBOutlet weak var registerButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appPurple
        registerButton.backgroundColor = UIColor(white: 1, alpha: 0.4)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func loginButtonTapped(_ sender: Any) {
        /*
        guard let authUI = FUIAuth.defaultAuthUI()
            else { return }
        
        authUI.delegate = self
        
        let providers: [FUIAuthProvider] = [FUIGoogleAuth(), FUIFacebookAuth()]
        authUI.providers = providers
        
        let authViewController = authUI.authViewController()
        present(authViewController, animated: true)
 */
        
    }
    @IBAction func facebookButtonTapped(_ sender: Any) {
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            // Perform login by calling Firebase APIs
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                
                guard let user = user
                    else {
                        self.registerButton.isEnabled = true
                        return }
                UserService.show(forUID: user.uid, completion:  { (user) in
                    if let user = user {
                        // handle existing user
                        User.setCurrent(user, writeToUserDefaults: true)
                        
                        let initialViewController = UIStoryboard.initialViewController(for: "Main")
                        self.view.window?.rootViewController = initialViewController
                        self.view.window?.makeKeyAndVisible()
                    } else {
                        // handle new user
                        self.performSegue(withIdentifier: Constants.Segues.toCreateUsername, sender: self)
                    }
                    self.registerButton.isEnabled = true
                    
                })
                
            })
            
        } 
        
    }
   
    @IBAction func googleButtonTapped(_ sender: Any) {
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

extension LoginViewController : FUIAuthDelegate{
        func authUI(_ authUI: FUIAuth, didSignInWith user: FIRUser?, error: Error?) {
            registerButton.isEnabled = false
            if let _ = error {
                registerButton.isEnabled = true
                //assertionFailure("Error signing in: \(error.localizedDescription)")
                return
            }
            
            guard let user = user
                else {
                    registerButton.isEnabled = true
                    return }
            
//            
//            // 2
//            let userRef = Database.database().reference().child(Constants.UserDefaults.key).child(user.uid)
//            
//            // 3
//            userRef.observeSingleEvent(of: .value, with: { (snapshot) in
//                if let user = User(snapshot: snapshot) {
//                    User.setCurrent(user)
//                    
//                    let storyboard = UIStoryboard(name: "Main", bundle: .main)
//                    if let initialViewController = storyboard.instantiateInitialViewController() {
//                        self.view.window?.rootViewController = initialViewController
//                        self.view.window?.makeKeyAndVisible()
//                    }
//                } else {
//                    self.performSegue(withIdentifier: Constants.Segues.toCreateUsername, sender: self)
//                }
//                self.registerButton.isEnabled = true
//
//            })
            
            
            
            UserService.show(forUID: user.uid) { (user) in
                if let user = user {
                    // handle existing user
                    User.setCurrent(user, writeToUserDefaults: true)
                    
                    let initialViewController = UIStoryboard.initialViewController(for: "Main")
                    self.view.window?.rootViewController = initialViewController
                    self.view.window?.makeKeyAndVisible()
                } else {
                    // handle new user
                    self.performSegue(withIdentifier: Constants.Segues.toCreateUsername, sender: self)
                }
                self.registerButton.isEnabled = true

            }
            
        }
        
        
        
    
}


