//
//  NodeMapController.swift
//  ProjectNode
//
//  Created by Jeffrey Weng on 7/31/17.
//  Copyright © 2017 Jeffrey Weng. All rights reserved.
//

import Foundation
import UIKit
class NodeMapController : UIViewController{
    @IBOutlet weak var nodeCreator: UIButton!
    @IBOutlet weak var node: UIButton!
    var nodeList : [Node] = [] //Has to be dictionary, each key contains an array of values[amount of nodes]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
    @IBAction func nodeCreatorTapped(_ sender: Any) {
        var newNode = Node(_distance: 20, _color: UIColor.blue, _size: 20, _name: "Hello World") //creates the random Node
        
        //Doesn't Work
        if nodeList.count < 3{
            for item in nodeList{
                while item.nodeObj().frame.equalTo(newNode.nodeObj().frame){
                    newNode = Node(_distance: 20, _color: UIColor.blue, _size: 20, _name: "Hello World")
                }
            }
        }
        
        
        //New Code ----------------------
    
        
        
        
        
        
        
        
        //----------------------
  
        self.view.addSubview(newNode.nodeObj())
        nodeList.append(newNode)
        
       /* Test Code, figures out the size of the rect object created for node placement
        let size = CGSize(width: 20 * 2, height: 20 * 2)
        //later on the center point will be the selected node
        let centerPoint = CGPoint(x : Int(UIScreen.main.bounds.width/2) - Int(size.width/2),y : Int(UIScreen.main.bounds.height/2) - Int(size.height/2))
        
        let tempRect = UIImageView(frame:CGRect(origin: centerPoint, size: size))
        tempRect.backgroundColor = UIColor.blue
        self.view.addSubview(tempRect)*/
        
    
        
    }
    

}
