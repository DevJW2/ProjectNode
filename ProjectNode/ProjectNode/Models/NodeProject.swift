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
    
    }/*
    let storageRef = Storage.storage().reference().child("myImage.png")
    
    if let uploadData = UIImagePNGRepresentation(projectPreviewImage){
        storageRef.putData(uploadData, metadata: nil, completion: {
            (metadata, error) in
            if error != nil{
                print(error)
                return
            }
            
            print(metaData)
        
        })
    }
 */
}
