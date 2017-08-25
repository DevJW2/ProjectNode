//
//  retrievingService.swift
//  ProjectNode
//
//  Created by Jeffrey Weng on 8/24/17.
//  Copyright © 2017 Jeffrey Weng. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseAuthUI
import FirebaseDatabase

struct retrievingService{

    
    static func obtainProject(){
        
        let ref: DatabaseReference = Database.database().reference()
        if let user = Auth.auth().currentUser{
            ref.child("projects").child(user.uid).observeSingleEvent(of: .value, with: {(snapshot)
                in
                
                
                guard let myProjectSnapshots = snapshot.children.allObjects as? [DataSnapshot] else {
                    return
                }
                
                for projectSnapshot in myProjectSnapshots {
                    let projectDict = projectSnapshot.value as? [String: Any]
                    let projectName = projectDict?["projectName"] as? String
                    let projectDate = projectDict?["projectDate"] as? String
                    let projectImageURLString = projectDict?["projectImage"] as? String
                    let projectStorageImageKey = projectDict?["projectStorageImageKey"] as? String

                    /*
                    guard let projectDict = projectSnapshot.value as? [String: Any],
                           let projectName = projectDict["projectName"] as? String,
                            let projectDate = projectDict["projectDate"] as? String,
                            let projectImageURLString = projectDict["projectImage"] as? String,
                            let projectStorageImageKey = projectDict["projectStorageImageKey"] as? String
                        else {
                            print("Error handling the snapshots.")
                            return
                    }*/
                    
                    
                    
                    self.receiveNodeProjects(projectName: projectName!, projectDate: projectDate!, projectImageURL: projectImageURLString, projectKey: projectSnapshot.key, storageKey: projectStorageImageKey)
                     //self.receiveNodeProjects(projectName: projectName, projectDate: projectDate, projectImageURL: projectImageURLString, projectKey: projectSnapshot.key, storageKey: projectStorageImageKey)
                   
                    //self.receiveNodeProjects(projectName: projectName, projectDate: projectDate, projectImageURL: projectImageURLString, projectKey: projectSnapshot.key, storageKey: projectStorageImageKey)
                    
                    // self.receiveNodeProjects(projectName: projectName, projectDate: projectDate, projectImageURL: "", projectKey: "", storageKey: "")
                    //print(nodeProjects)
                    
                }
                
                
                
            })
        }

    }
    
    static func updateProject(){
        
        let ref: DatabaseReference = Database.database().reference()
        if let user = Auth.auth().currentUser{
            ref.child("projects").child(user.uid).observeSingleEvent(of: .value, with: {(snapshot)
                in
                
                
                guard let myProjectSnapshots = snapshot.children.allObjects as? [DataSnapshot] else {
                    return
                }
                
                for projectSnapshot in myProjectSnapshots {
                    let projectDict = projectSnapshot.value as? [String: Any]
                    let projectName = projectDict?["projectName"] as? String
                    let projectDate = projectDict?["projectDate"] as? String
                    let projectImageURLString = projectDict?["projectImage"] as? String
                    let projectStorageImageKey = projectDict?["projectStorageImageKey"] as? String
                    
                    /*
                     guard let projectDict = projectSnapshot.value as? [String: Any],
                     let projectName = projectDict["projectName"] as? String,
                     let projectDate = projectDict["projectDate"] as? String,
                     let projectImageURLString = projectDict["projectImage"] as? String,
                     let projectStorageImageKey = projectDict["projectStorageImageKey"] as? String
                     else {
                     print("Error handling the snapshots.")
                     return
                     }*/
                    
                    
                    
                    self.receiveUpdateNodeProjects(projectName: projectName!, projectDate: projectDate!, projectImageURL: projectImageURLString, projectKey: projectSnapshot.key, storageKey: projectStorageImageKey)
                    //self.receiveNodeProjects(projectName: projectName, projectDate: projectDate, projectImageURL: projectImageURLString, projectKey: projectSnapshot.key, storageKey: projectStorageImageKey)
                    
                    //self.receiveNodeProjects(projectName: projectName, projectDate: projectDate, projectImageURL: projectImageURLString, projectKey: projectSnapshot.key, storageKey: projectStorageImageKey)
                    
                    // self.receiveNodeProjects(projectName: projectName, projectDate: projectDate, projectImageURL: "", projectKey: "", storageKey: "")
                    print(nodeProjects)
                    
                }
                
                
                
            })
        }
        
    }
    
    //Reads the node data
    static func obtainNode(){
        
    
    
    }
    
    
    static func receiveNodeProjects(projectName: String, projectDate: String, projectImageURL: String?, projectKey: String, storageKey: String?){
        
        let node = NodeProject()
        node.projectName = projectName
        node.projectDate = projectDate
        //node.projectPreviewImage = projectImage
        node.previewImageURL = projectImageURL
        node.specificKey = projectKey
        node.currentImageName = storageKey
        
        nodeProjects.append(node)
    }
    
    static func receiveUpdateNodeProjects(projectName: String, projectDate: String, projectImageURL: String?, projectKey: String, storageKey: String?){
        for node in nodeProjects{
            node.projectName = projectName
            node.projectDate = projectDate
            //node.projectPreviewImage = projectImage
            node.previewImageURL = projectImageURL
            node.specificKey = projectKey
            node.currentImageName = storageKey

        }
    }
    
    //function used to generate the nodes
    //nodes need to remember their parent and the connector lines and such..
    
    
    static func receiveNodes() -> UIButton{
        /*let ancestorNode = Node(_distance: 100, _color: nodeColor, _size: nodeSize, _name: "Hi!", _descript: "", _nodeLimit: 3, _xCoordinate: Double(UIScreen.main.bounds.width/2), _yCoordinate: Double(UIScreen.main.bounds.height/2))*/
        
        let node = Node(_distance: 100, _color: retrievedFirebaseColor, _size: 50, _name: retrievedFirebaseName, _descript: retrievedFirebaseDescription, _nodeLimit: retrievedFirebaseNodeLimit, _xCoordinate: retrievedFirebaseX, _yCoordinate: retrievedFirebaseY)
        
        nodeList.append(node)
        
        return node.getNode()
        
        
    }
    


}
