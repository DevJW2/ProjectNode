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

    @IBOutlet weak var shapeControl: UISegmentedControl!
    @IBOutlet weak var nodeDescription: UITextView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var doneEdit: UIButton!
    @IBOutlet weak var nodeLimitValue: UILabel!
    @IBOutlet weak var nodeLimitSliderObj: UISlider!

    @IBOutlet weak var textColorSegment: UISegmentedControl!

    @IBOutlet weak var borderColorSegment: UISegmentedControl!
    let originalButtonWidth = CGFloat(selectedNode!.getSize())
    let neatColorPicker = ChromaColorPicker(frame: CGRect(x: UIScreen.main.bounds.width/2 - 125, y: UIScreen.main.bounds.height/2 - 125, width: 250, height: 250))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        neatColorPicker.delegate = self as? ChromaColorPickerDelegate //ChromaColorPickerDelegate
        neatColorPicker.padding = 5
        neatColorPicker.stroke = 3
        neatColorPicker.hexLabel.textColor = UIColor.white
        neatColorPicker.addButton.isEnabled = false
        //neatColorPicker.supportsShadesOfGray = true
        
        view.addSubview(neatColorPicker)
        
        nameTextField.delegate = self
        
        //set values of the nodeEditor into the node
        nameTextField.text = selectedNode!.getName()
        neatColorPicker.adjustToColor(selectedNode!.getNode().backgroundColor!)
        nodeLimitSliderObj.value = Float(selectedNode!.getNodeLimit())
        nodeLimitValue.text = String(Int(selectedNode!.getNodeLimit()))
        if selectedNode!.previousBorderColor == UIColor.black{
            borderColorSegment.selectedSegmentIndex = 0
        }
        else if selectedNode!.previousBorderColor == UIColor.white{
            borderColorSegment.selectedSegmentIndex = 1
        }
        
        if selectedNode!.getNode().titleLabel?.textColor == UIColor.black{
            textColorSegment.selectedSegmentIndex = 0
        }
        else if selectedNode!.getNode().titleLabel?.textColor == UIColor.white{
            textColorSegment.selectedSegmentIndex = 1
        }
        
        if selectedNode!.getNode().layer.cornerRadius == 0{
            shapeControl.selectedSegmentIndex = 1
        }
        else{
            shapeControl.selectedSegmentIndex = 0
        }
            
        nodeDescription.text = selectedNode!.descript

        
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
 
        updateNodeProperties()
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nodeLimitSlider(_ sender: UISlider) {
        nodeLimitValue.text = String(Int(sender.value))
    }


    
    
    func updateNodeProperties(){
        
        //Name
        if nameTextField.text != nil{
            selectedNode!.getNode().setTitle(nameTextField.text!, for: UIControlState.normal)
            selectedNode!.setName(text: nameTextField.text!)
        }
        //Color
        selectedNode!.getNode().backgroundColor = neatColorPicker.currentColor
        selectedNode!.setColor(value: neatColorPicker.currentColor)
        
        //Dynamic Resizing
        if  originalButtonWidth < selectedNode!.getNode().titleLabel!.intrinsicContentSize.width{
            selectedNode!.getNode().contentEdgeInsets = UIEdgeInsets(top: 12,left: 10,bottom: 12,right: 10)
            selectedNode!.getNode().sizeToFit()
            if shapeControl.selectedSegmentIndex == 0{
                selectedNode!.getNode().layer.cornerRadius = selectedNode!.getNode().frame.height/2
            }
            else if shapeControl.selectedSegmentIndex == 1{
                selectedNode!.getNode().layer.cornerRadius = 0
            }
            
            
        }
        else if originalButtonWidth > selectedNode!.getNode().titleLabel!.intrinsicContentSize.width{
            selectedNode!.getNode().frame.size = CGSize(width: 50.0, height: 50.0)
            selectedNode!.getNode().contentEdgeInsets = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
            if shapeControl.selectedSegmentIndex == 0{
                selectedNode!.getNode().layer.cornerRadius = 25.0
            }
            else if shapeControl.selectedSegmentIndex == 1{
                selectedNode!.getNode().layer.cornerRadius = 0
            }
        }
        
        
        //Node Limit
        selectedNode!.setNodeLimit(value: Int(nodeLimitValue.text!)!)
        
        //Text Color
        if textColorSegment.selectedSegmentIndex == 0{
            selectedNode!.getNode().setTitleColor(UIColor.black, for: .normal)
        }
        else if textColorSegment.selectedSegmentIndex == 1{
            selectedNode!.getNode().setTitleColor(UIColor.white, for: .normal)
        }
        //Border Color
        if borderColorSegment.selectedSegmentIndex == 0{
            selectedNode!.getNode().layer.borderColor = UIColor.black.cgColor
            selectedNode!.setPreviousBorderColor(value: UIColor.black)
            selectedNode!.setBorderColor(value: UIColor.black)
        }
        else if borderColorSegment.selectedSegmentIndex == 1{
            selectedNode!.getNode().layer.borderColor = UIColor.white.cgColor
            selectedNode!.setPreviousBorderColor(value: UIColor.white)
            selectedNode!.setBorderColor(value: UIColor.white)
        }
        
        //Node Description
        selectedNode!.setDescription(text: nodeDescription.text)


    }
    
    
    //Get rid of keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        self.view.endEditing(true)
        return false
    }

}
