//
//  LoginControl.swift
//  ProjectNode
//
//  Created by Jeffrey Weng on 7/25/17.
//  Copyright © 2017 Jeffrey Weng. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseAuthUI
import FirebaseDatabase


class LoginControl : UIViewController{
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgetPassword: UIButton!
    @IBOutlet weak var forgetPasswordBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loginButton.layer.cornerRadius = 12
        NotificationCenter.default.addObserver(self, selector: #selector( keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        emailTextField.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func keyboardWillShow(notification: NSNotification){
        if let info = notification.userInfo{
            let rect: CGRect = info["UIKeyboardFrameEndUserInfoKey"] as! CGRect
            
            self.view.layoutIfNeeded()
            
            if UIDevice.current.orientation.isPortrait{
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
                self.forgetPasswordBottomConstraint.constant = rect.height + 20
            
                })
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification){
        if let info = notification.userInfo{
            //let rect: CGRect = info["UIKeyboardFrameEndUserInfoKey"] as! CGRect
            
            self.view.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.25, animations:{
                self.view.layoutIfNeeded()
                self.forgetPasswordBottomConstraint.constant = 20
            })
        }
    }

    @IBAction func forgetPasswordTapped(_ sender: Any) {
    }
    
    func exit(){
        self.performSegue(withIdentifier: "unwindLogin", sender: self)
    }

    @IBAction func loginButtonTapped(_ sender: Any) {
        //ADD CHANGING EMAIL AND PASSWORD FUNCTIONALITY
        self.loginButton.isEnabled = false
        if let email = emailTextField.text, let password = passwordTextField.text{

            
                    Auth.auth().signIn(withEmail: email.trimmingCharacters(in: .whitespaces), password: password) { (user, error) in
            
                        //Code Block--------------------------------
                        if let user = user{
                            //user is found, go to new screen
                            LoadingOverlay.shared.showOverlay(view: self.view) // Animation
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                                LoadingOverlay.shared.hideOverlayView()
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let vc = storyboard.instantiateViewController(withIdentifier: "mainPage")
                                self.present(vc, animated: true, completion: nil)
                            })
                            //LoadingOverlay.shared.hideOverlayView()
                        }
                        else{
                            //check error and show message
                            let connectedRef = Database.database().reference(withPath: ".info/connected")
                            connectedRef.observe(.value, with: { snapshot in
                                if let connected = snapshot.value as? Bool, connected {
                                    let alert = UIAlertController(title: "", message: "Incorrect email or password", preferredStyle: UIAlertControllerStyle.alert)
                                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                    self.loginButton.isEnabled = true
                                }
                                else{
                                    
                                    let alert = UIAlertController(title: "", message: "Lost Connection", preferredStyle: UIAlertControllerStyle.alert)
                                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: { action in
                                        self.exit()
                                    }))
                                    self.present(alert, animated: true, completion: nil)
                                    self.loginButton.isEnabled = true
                                    
                                }
                            })
                            

                        }
                        //End of Code Block--------------------------------
                    }
                

            
        }
    }
}
