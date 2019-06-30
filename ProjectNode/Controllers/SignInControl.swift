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
    @IBOutlet weak var lastNameTextField: MadokaTextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var signinNavBar: UINavigationBar!
    
    var ref: DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        signinButton.layer.cornerRadius = 12
        ref = Database.database().reference()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //NSApplication.sharedApplication().windows[0].makeFirstResponder(nameTextField)
        nameTextField.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Validity Functionality
    //-----------------------------------------------------------------
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: testStr)
    }
    
    func isValidPassword(pass: String) -> Bool{
        if (pass.trimmingCharacters(in: .whitespaces).isEmpty) || pass.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: " ", with: "").characters.count < 7{
            return false
        }
        return true
    }
    
    func exit(){
        self.performSegue(withIdentifier: "unwindSign", sender: self)
    }
    
    //-----------------------------------------------------------------


    @IBAction func signinButtonTapped(_ sender: Any) {
        self.signinButton.isEnabled = false
        //Put Name in Database
        var correctName : Bool = false
        if let name = nameTextField.text{
            if !(name.trimmingCharacters(in: .whitespaces).isEmpty){
                correctName = true
            }
        }
        //Checking for Errors
        if correctName == true{
            if let email = emailTextField.text, let password = passwordTextField.text{
                if isValidEmail(testStr: email){
                   if isValidPassword(pass: password){
                    
                    let connectedRef = Database.database().reference(withPath: ".info/connected")
                    connectedRef.observe(.value, with: { snapshot in
                        if let connected = snapshot.value as? Bool, connected {
                            print("connected")

                    
                            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                                if let user = user{
                                    //user is found, go to new screen
                                    LoadingOverlay.shared.showOverlay(view: self.view) //Animation
                                    self.ref?.child("users").child(user.uid).setValue(["name": (self.nameTextField.text?.trimmingCharacters(in: .whitespaces))! + " " + (self.lastNameTextField.text?.trimmingCharacters(in: .whitespaces))!])
                                    //self.ref?.child("projects").setValue(["":""])
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                                        LoadingOverlay.shared.hideOverlayView()
                                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                        let vc = storyboard.instantiateViewController(withIdentifier: "mainPage")
                                        self.present(vc, animated: true, completion: nil)
                                    })
                                    
                                }
                                else{
                                    //check error and show message
                                    print(error!)
                                    if(error?._code == 17007) {
                                        let alert = UIAlertController(title: "", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                                        self.present(alert, animated: true, completion: nil)
                                        self.signinButton.isEnabled = true
                                    }
                                }
                            }
                        }
                        else{
                            
                            let alert = UIAlertController(title: "", message: "Lost Connection", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: { action in
                                self.exit()
                            }))
                            self.present(alert, animated: true, completion: nil)
                            self.signinButton.isEnabled = true
                            

                        }
                    })
                    
                   }else{
                        let alert = UIAlertController(title: "", message: "Password has to be at least 7 characters long", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    self.signinButton.isEnabled = true
                    }
                }
                else{
                    let alert = UIAlertController(title: "", message: "Invalid Email", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    self.signinButton.isEnabled = true

                }
            }
        }else{
            let alert = UIAlertController(title: "", message: "Name must be at least one character long", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.signinButton.isEnabled = true
            
        }
    }

}

