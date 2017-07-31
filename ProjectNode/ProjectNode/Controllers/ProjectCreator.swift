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
class ProjectCreator : UIViewController{
    
    weak var delegate: ProjectCreatorDelegate?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var creatorView: UIView!
    @IBOutlet weak var tagSelection: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        creatorView.layer.cornerRadius = 12
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
    



}
