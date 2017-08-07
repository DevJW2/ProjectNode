//
//  ProjectCreator.swift
//  ProjectNode
//
//  Created by Jeffrey Weng on 7/27/17.
//  Copyright © 2017 Jeffrey Weng. All rights reserved.
//


protocol ProjectCreatorDelegate : class{
    func formCompleted(nameProject : String?, tag : Int?)
}


import Foundation
import UIKit
class ProjectCreator : UIViewController, UITextFieldDelegate{
    
    weak var delegate: ProjectCreatorDelegate?
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var creatorView: UIView!
    @IBOutlet weak var tagSelection: UISegmentedControl!
    
    @IBOutlet weak var exitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        creatorView.layer.cornerRadius = 12
        doneButton.layer.cornerRadius = 14
        nameTextField.delegate = self
        
    }

    @IBAction func doneButtonTapped(_ sender: Any) {
        if nameTextField.text?.trimmingCharacters(in: .whitespaces) == ""{
            let alert = UIAlertController(title: "", message: "Insert a name", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)

        }else{
            
            delegate?.formCompleted(nameProject: nameTextField.text, tag: tagSelection.selectedSegmentIndex)
            dismiss(animated: true, completion:nil)
        }
    }
    
    @IBAction func exitButtonTapped(_ sender: Any) {
          dismiss(animated: true, completion:nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        self.view.endEditing(true)
        return false
    }

    
    



}
