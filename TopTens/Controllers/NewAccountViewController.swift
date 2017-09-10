//
//  NewAccountViewController.swift
//  TopTens
//
//  Created by Kyle Somers on 8/31/17.
//  Copyright © 2017 Kyle Somers. All rights reserved.
//

import UIKit
import FirebaseAuth

class NewAccountViewController: UIViewController {
    
    var newlyCreatedUser : FIRUser?
    var password : String?
    var initialFrame : CGRect = CGRect()
    private var alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)


    @IBOutlet weak var movingView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var retypePasswordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var fullNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var retypePasswordLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okButton)
        
 
        
        print(initialFrame)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func nextButtonTapped(_ sender: Any) {
        guard let emailText = emailField.text,
            let passwordText = passwordField.text,
            let retypePasswordText = retypePasswordField.text,
            let fullNameText = fullNameField.text,
            emailText != "",
            passwordText != "",
            retypePasswordText != "",
            fullNameText != ""
            else{
                self.alertController.title = "All fields are required."
                self.alertController.message = ""
                self.present(self.alertController, animated: true, completion: nil)
                return
        
            }
            
        if !isValidEmail(testStr: emailText){
            self.alertController.title = "Enter a valid email."
            self.alertController.message = ""
            self.present(self.alertController, animated: true, completion: nil)
            return
        }
    
    
        else if passwordText.characters.count < 6 || passwordText.characters.count > 20{
            self.alertController.title = "Your password must be between 6 and 20 characters."
            self.alertController.message = ""
            self.present(self.alertController, animated: true, completion: nil)
            return
        }

        else if retypePasswordText != passwordText{
            self.alertController.title = "Your your passwords don't match."
            self.alertController.message = ""
            self.present(self.alertController, animated: true, completion: nil)
            return
        }

        else if fullNameText == "" || !fullNameText.containsOnlyLettersAndSpaces(){
            self.alertController.title = "Please enter your name. It can only contain letters."
            self.alertController.message = ""
            self.present(self.alertController, animated: true, completion: nil)
            return
        }
        else if fullNameText.characters.count > 25{
            self.alertController.title = "Do you have a shorter version of your name?"
            self.alertController.message = "Max character count is 25."
            self.present(self.alertController, animated: true, completion: nil)
            return
        }
        else{
            Auth.auth().createUser(withEmail: emailText, password: passwordText, completion: {(user, error) in
                
                if let error = error{
                    print(error)
                    if error.localizedDescription.lowercased().contains("network error"){
                        self.alertController.title = "Network Error."
                        self.alertController.message = "Make sure you have an internet connection."
                        self.present(self.alertController, animated: true, completion: nil)
                    }
                    else{
                        self.alertController.title = "An account with this email already exists."
                        self.alertController.message = "If you've started setting up an account with this email but haven't finished, go back, log in with your username and password, and you can finish the sign up process from there."
                        self.present(self.alertController, animated: true, completion: nil)
                    }
                    
                }
                else{
                    
                    
                    guard let user = user else {return}
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = fullNameText
                    changeRequest.commitChanges { error in
                        if let _ = error {
                            print("problem with setting the full name")
                        } else {
                            
                            self.newlyCreatedUser = user
                            user.sendEmailVerification(completion: nil)
                            self.password = passwordText
                            self.performSegue(withIdentifier: "toConfirmationEmail", sender: self)
                        }
                    }
                    
                    
                    
                    
                }
                
            })
        }
        
        
        
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! ValidationEmailViewController
        if let newlyCreatedUser = newlyCreatedUser{
            nextVC.user = newlyCreatedUser
            nextVC.password = self.password
        }
    }
    

}
extension NewAccountViewController : UIGestureRecognizerDelegate {
    
    
    
    func handleTap(_ gestureRecognizer : UIGestureRecognizer){
        
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        retypePasswordField.resignFirstResponder()
        fullNameField.resignFirstResponder()
        self.scrollView.setContentOffset(CGPoint(x:0, y:0), animated: true)
        
    }
    @IBAction func takeDownTheKeyboard(_ sender: Any) {
        print("keyboard retired")
        self.scrollView.setContentOffset(CGPoint(x:0, y:0), animated: true)
    }
    

    
    @IBAction func textFiedStartedEditing(_ sender : UITextField){
        
        if sender == emailField || sender == fullNameField{
            self.scrollView.setContentOffset(CGPoint(x:0, y:0), animated: true)
            
        }
        else if sender == passwordField{
            guard let fullnameRect = fullNameLabel.superview?.convert(fullNameLabel.frame, to: movingView) else{print("weird error"); return}
            print(fullnameRect)
            self.scrollView.setContentOffset(CGPoint(x: 0, y:  fullnameRect.origin.y), animated: true)
        }
        else if sender == retypePasswordField{
            guard let passwordRect = passwordLabel.superview?.convert(passwordLabel.frame, to: movingView) else{print("weird error"); return}
            self.scrollView.setContentOffset(CGPoint(x: 0, y:  passwordRect.origin.y), animated: true)
            
            
            
        }
        
        
    }
    
}
