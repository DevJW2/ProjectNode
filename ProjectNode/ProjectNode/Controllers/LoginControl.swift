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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loginButton.layer.cornerRadius = 12
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginButtonTapped(_ sender: Any) {
        //ADD CHANGING EMAIL AND PASSWORD FUNCTIONALITY
        self.loginButton.isEnabled = false
        if let email = emailTextField.text, let password = passwordTextField.text{
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if let user = user{
                    //user is found, go to new screen
                    LoadingOverlay.shared.showOverlay(view: self.view)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "mainPage")
                    self.present(vc, animated: true, completion: nil)
                    LoadingOverlay.shared.hideOverlayView()
                }
                else{
                    //check error and show message
                    let alert = UIAlertController(title: "", message: "Incorrect email or password", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    self.loginButton.isEnabled = true

                }
            }
            
        }
    }

}
