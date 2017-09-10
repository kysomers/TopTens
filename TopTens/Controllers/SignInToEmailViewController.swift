//
//  SignInToEmailViewController.swift
//  TopTens
//
//  Created by Kyle Somers on 8/31/17.
//  Copyright © 2017 Kyle Somers. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInToEmailViewController: UIViewController {

    var loggingInUser : FIRUser?
    var password : String?
    private var alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
    
    @IBOutlet weak var movingView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var newAccountButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okButton)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        takeDownTheKeyboard(self)
        
        guard let emailText = emailTextField.text,
            emailText != "",
            let passwordText = passwordTextField.text,
            passwordText != ""
            else{return}
        
        Auth.auth().signIn(withEmail: emailText, password: passwordText, completion: {(user, error) in
        
            if let error = error{
                print(error.localizedDescription)
                self.alertController.title = "Login Error"
                self.alertController.message = "Make sure you have the right password and that you are connected to the internet."
                self.present(self.alertController, animated: true, completion: nil)
                //TODO show an error
                
                
            }
            else{
                guard let user = user else{return}
                if !user.isEmailVerified{
                    self.loggingInUser = user
                    self.password = passwordText
                    self.performSegue(withIdentifier: "toEmailVerification", sender: self)
                }
                else{
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
                        
                    })
                }
                
            }
            
        })
        
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toEmailVerification", let nextVC = segue.destination as? ValidationEmailViewController{
            nextVC.user = loggingInUser
            nextVC.password = password
        }
    }
    

}


extension SignInToEmailViewController : UIGestureRecognizerDelegate {
    

    
    func handleTap(_ gestureRecognizer : UIGestureRecognizer){
        
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        self.scrollView.setContentOffset(CGPoint(x:0, y:0), animated: true)


    }
    @IBAction func takeDownTheKeyboard(_ sender: Any) {
        print("keyboard retired")
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        self.scrollView.setContentOffset(CGPoint(x:0, y:0), animated: true)

    }

    
    
    

    func keyboardWillShow(notification: NSNotification) {
        
        
        guard let passwordRect = passwordTextField.superview?.convert(passwordTextField.frame, to: movingView) else{print("weird error"); return}
        
        print(passwordRect)
        if let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{

            if self.view.frame.height - keyboardFrame.height < passwordRect.maxY {


                guard let emailRect = emailLabel.superview?.convert(emailLabel.frame, to: movingView) else{print("weird error"); return}
                self.scrollView.setContentOffset(CGPoint(x: 0, y:  emailRect.origin.y - 20), animated: true)
            }
        }
        // do stuff with the frame...
    }

}
