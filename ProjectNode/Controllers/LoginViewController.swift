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
        loginButton.layer.borderColor = UIColor.white.cgColor
        loginButton.layer.borderWidth = 1
        loginButton.layer.cornerRadius = 4
        
        signupButton.layer.borderColor = UIColor.white.cgColor
        signupButton.layer.borderWidth = 1
        signupButton.layer.cornerRadius = 4
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask(rawValue: UInt(Int(UIInterfaceOrientationMask.portrait.rawValue)))
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
    }

    @IBAction func signupButtonTapped(_ sender: Any) {
    }
    
    @IBAction func unwindToLoginViewController(segue: UIStoryboardSegue) {
    }
}
