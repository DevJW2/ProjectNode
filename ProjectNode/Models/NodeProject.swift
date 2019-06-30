//
//  NodeProject.swift
//  ProjectNode
//
//  Created by Jeffrey Weng on 7/31/17.
//  Copyright © 2017 Jeffrey Weng. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseAuthUI
import FirebaseStorage




class NodeProject : NSObject{
    var projectPreviewButton: UIButton?
    var projectPreviewImage : UIImage? //Update
    var projectName : String? //Update
    var projectDate : String? //Update
    var collaboratorCount : Int?
    var chosenTag : UIColor?
    //var myNodes = [Node]()
    var previewImageURL : String? //Update
    var specificKey : String? //Update
    var currentImageName: String? //Update
    
    var assignedProject : UIButton?
    
    var dictValue: [String: Any]{
        
        return [
            "projectName" : projectName,
            "projectDate" : projectDate,
            "projectImage" : previewImageURL,
            "projectStorageImageKey" : currentImageName,
        ]
    
    }
}
