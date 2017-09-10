//
//  ValidationEmailViewController.swift
//  TopTens
//
//  Created by Kyle Somers on 8/31/17.
//  Copyright © 2017 Kyle Somers. All rights reserved.
//

import UIKit
import FirebaseAuth

class ValidationEmailViewController: UIViewController {

    var user : FIRUser?
    var password : String?
    private var alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)

    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var instructionsLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okButton)


    }
    override func viewWillAppear(_ animated: Bool) {
        guard let user = user, let userEmail = user.email else {return}
        instructionsLabel.text = "A confirmation email has been sent to \(userEmail). You probably know the drill: go to your email, do what it says, and come back here so you can pick a username and get started making lists."
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func doneButtonTapped(_ sender: Any) {
        //TODO: - need to temporarily disable buttons
        guard let user = user, let password = password, let email = user.email else{return}
        Auth.auth().signIn(withEmail: email, password: password, completion: {(user, error) in
            guard let user = user else {return}
            if user.isEmailVerified{
                self.performSegue(withIdentifier: "toCreateUsername", sender: self)
            }
            else{
                self.alertController.title = "Your email hasn't been verified yet."
                self.alertController.message = "If you went to your email and clicked the link, give it another couple seconds. It might be a slow connection. Otherwise, you can have the verification email resent."
                self.present(self.alertController, animated: true, completion: nil)
                print("SHOW ALERT THAT The email still hasn't been verified")
            }
            
        })
    }

    @IBAction func resendEmailButton(_ sender: Any) {
        
        guard let user = user else{return}
        user.sendEmailVerification(completion: {error in
            if let _ = error{
                self.alertController.title = "There was a problem resending the verification email."
                self.alertController.message = ""
                self.present(self.alertController, animated: true, completion: nil)
            }
            else{
                self.alertController.title = "Verification email resent."
                self.alertController.message = ""
                self.present(self.alertController, animated: true, completion: nil)
            }
        
        })

        
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
