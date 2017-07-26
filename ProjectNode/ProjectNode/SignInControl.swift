//
//  SignInControl.swift
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

class SignInControl : UIViewController{
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var signinNavBar: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        signinNavBar.layer.borderColor = UIColor.white.cgColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signinButtonTapped(_ sender: Any) {
        //do form validation

        //password hidden 
        //name can't be symbols, can't be blank
        //check if it is an email
        //password has to be a certain length

        
        
        if let email = emailTextField.text, let password = passwordTextField.text{
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if let user = user{
                    //user is found, go to new screen
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "mainPage")
                    self.present(vc, animated: true, completion: nil)
                }
                else{
                    //check error and show message
                }
            }
        }
    }

}

