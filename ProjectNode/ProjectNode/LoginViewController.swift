//
//  LoginViewController.swift
//  ProjectNode
//
//  Created by Jeffrey Weng on 7/25/17.
//  Copyright © 2017 Jeffrey Weng. All rights reserved.
//

import Foundation

import UIKit

class LoginViewController: UIViewController {
    
   
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
    }

    @IBAction func signupButtonTapped(_ sender: Any) {
    }
    
    @IBAction func unwindToLoginViewController(segue: UIStoryboardSegue) {
    }
}
