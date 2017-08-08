//
//  NodeEditorController.swift
//  ProjectNode
//
//  Created by Jeffrey Weng on 8/8/17.
//  Copyright © 2017 Jeffrey Weng. All rights reserved.
//

protocol NodeEditorControllerDelegate: class{
    func nodeProperties(item: String)

}


import Foundation
import UIKit
import ChromaColorPicker

class NodeEditorController : UIViewController{
    
    weak var delegate: NodeEditorControllerDelegate?

    
    @IBOutlet weak var doneEdit: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let neatColorPicker = ChromaColorPicker(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        neatColorPicker.delegate = self as? ChromaColorPickerDelegate //ChromaColorPickerDelegate
        neatColorPicker.padding = 5
        neatColorPicker.stroke = 3
        neatColorPicker.hexLabel.textColor = UIColor.black
        neatColorPicker.supportsShadesOfGray = true
        
        view.addSubview(neatColorPicker)
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first{
            if touch.view == self.view{
                dismiss(animated: true, completion:nil)
            }
            else{
                return
            }
        }
    }
    
    @IBAction func doneEditTapped(_ sender: Any) {
        delegate?.nodeProperties(item: "value")
        dismiss(animated: true, completion: nil)
    }
    

}
