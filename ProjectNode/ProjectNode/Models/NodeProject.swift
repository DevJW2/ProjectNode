//
//  NodeProject.swift
//  ProjectNode
//
//  Created by Jeffrey Weng on 7/31/17.
//  Copyright © 2017 Jeffrey Weng. All rights reserved.
//

import Foundation
import UIKit

class NodeProject : NSObject{
    var projectPreviewButton: UIButton?
    var projectPreviewImage : UIImage?
    var projectName : String?
    var projectDate : String?
    var collaboratorCount : Int?
    var chosenTag : UIColor?
    var myNodes = [Node]()
    
    var dictValue: [String: Any]{
        
        return [
            "projectName" : projectName,
            "projectDate" : projectDate
            
        
        ]
    
    }
}
