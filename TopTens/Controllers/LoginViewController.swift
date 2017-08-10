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
        
        // 1
        guard let authUI = FUIAuth.defaultAuthUI()
            else { return }
        
        // 2
        authUI.delegate = self
        
        // 3
        let authViewController = authUI.authViewController()
        present(authViewController, animated: true)
        
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
            if let error = error {
                assertionFailure("Error signing in: \(error.localizedDescription)")
                return
            }
            
            guard let user = user
                else { return }
            
            
            // 2
            let userRef = Database.database().reference().child("users").child(user.uid)
            
            // 3
            userRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let user = User(snapshot: snapshot) {
                    User.setCurrent(user)
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: .main)
                    if let initialViewController = storyboard.instantiateInitialViewController() {
                        self.view.window?.rootViewController = initialViewController
                        self.view.window?.makeKeyAndVisible()
                    }
                } else {
                    self.performSegue(withIdentifier: Constants.Segues.toCreateUsername, sender: self)
                }
            })
            
            
            
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
            }
            
        }
        
        
        
    
}

extension UIStoryboard{
    static func initialViewController(for storyboardName:String) -> UIViewController{
        let storyboard = UIStoryboard(name: storyboardName, bundle: .main)
        if let initialViewController = storyboard.instantiateInitialViewController(){
            return initialViewController
        }
        else{
            return UIViewController()
        }
    }
}
