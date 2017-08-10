//
//  NodeEditorController.swift
//  ProjectNode
//
//  Created by Jeffrey Weng on 8/8/17.
//  Copyright © 2017 Jeffrey Weng. All rights reserved.
//

protocol NodeEditorControllerDelegate: class{
    func nodeProperties(name: String, color: UIColor, size: Double)

}


import Foundation
import UIKit
import ChromaColorPicker

class NodeEditorController : UIViewController, UITextFieldDelegate{
    
    weak var delegate: NodeEditorControllerDelegate?

    
    @IBOutlet weak var sizeSlider: UISlider!
    @IBOutlet weak var nodeDescription: UITextView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var doneEdit: UIButton!
    
    let neatColorPicker = ChromaColorPicker(frame: CGRect(x: UIScreen.main.bounds.width/2 - 150, y: UIScreen.main.bounds.height/2 - 250, width: 300, height: 300))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        neatColorPicker.delegate = self as? ChromaColorPickerDelegate //ChromaColorPickerDelegate
        neatColorPicker.padding = 5
        neatColorPicker.stroke = 3
        neatColorPicker.hexLabel.textColor = UIColor.black
        neatColorPicker.supportsShadesOfGray = true
        
        view.addSubview(neatColorPicker)
        
        nameTextField.delegate = self
        
    }
    /*override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first{
            if touch.view == self.view{
                dismiss(animated: true, completion:nil)
            }
            else{
                return
            }
        }
    }*/
    
    @IBAction func exitEditTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func doneEditTapped(_ sender: Any) {
        delegate?.nodeProperties(name: "Value", color: UIColor.green, size: 10.0)
        //you should delete this later and edit accordingly
        if nameTextField.text != nil{
            selectedNode!.getNode().setTitle(nameTextField.text!, for: UIControlState.normal)
            selectedNode!.name = nameTextField.text!
            //selectedNode!.getNode().backgroundColor = neatColorPicker.currentColor
            
        }
        //--------------------------------------
        dismiss(animated: true, completion: nil)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        self.view.endEditing(true)
        return false
    }

}
