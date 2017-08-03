//
//  NodeMapController.swift
//  ProjectNode
//
//  Created by Jeffrey Weng on 7/31/17.
//  Copyright © 2017 Jeffrey Weng. All rights reserved.
//

import Foundation
import UIKit

var selectedNode : Node?

class NodeMapController : UIViewController{
    @IBOutlet weak var nodeCreator: UIButton!
    var nodeList : [Node] = [] //Has to be dictionary, each key contains an array of values[amount of nodes]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        let ancestorNode = Node(_distance: 50, _color: UIColor.blue, _size: 20, _name: "Hello World", _xCoordinate: Double(UIScreen.main.bounds.width/2), _yCoordinate: Double(UIScreen.main.bounds.height/2))
        nodeList.append(ancestorNode)
        self.view.addSubview(ancestorNode.getNode())
    
        //NotificationCenter.default.addObserver(self, selector: #selector(highlightNode), name: NSNotification.Name(rawValue: "selectedNodeNotification"), object: nil)
        
    }
    
    @IBAction func nodeCreatorTapped(_ sender: Any) {
        if selectedNode!.getLimit() < 5{
            let newNode = Node(_distance: 50, _color: UIColor.blue, _size: 20, _name: "Hello World")
            nodeList.append(newNode)
            self.view.addSubview(newNode.getNode())
            selectedNode!.nodeLimit += 1
        }
        else{
            print("can't print any more nodes")
        }
        
        
    }
    
    


}
/* PREVIOUS CODE
 
//DO NOT USE CGRECT COMPARATORS

func addNode(){
    //var newNode = Node(_distance: 20, _color: UIColor.blue, _size: 20, _name: "Hello World")
    var flag = false
    if nodeList.count == 0{
        let newNode = Node(_distance: 20, _color: UIColor.blue, _size: 20, _name: "Hello World")
        nodeList.append(newNode)
        self.view.addSubview(newNode.nodeObj())
        print("FIRST NODE CREATED")
    }
    else{
        while flag == false{
            let newNode = Node(_distance: 20, _color: UIColor.blue, _size: 20, _name: "Hello World")
            for index in 0..<nodeList.count{
                print("Index: ")
                print(index)
                print("Node List: ")
                print(nodeList)
                print("first Node frame: ")
                print(nodeList[0].nodeObj().frame)
                print("New node created: ")
                print(newNode.nodeObj().frame)
                print("equal or not")
                print(newNode.nodeObj() == nodeList[index].nodeObj())
                print("node list length")
                print(nodeList.count - 1)
                if (newNode.nodeObj().frame != nodeList[index].nodeObj().frame) && (index == nodeList.count - 1){
                    print("ENTERED IF STATEMENT")
                    print("New Node Rect: ")
                    print(newNode.nodeObj().frame)
                    print("Existing Node Rect: ")
                    print(nodeList[index].nodeObj().frame)
                    
                    nodeList.append(newNode)
                    print("NEW NODE CREATED")
                    self.view.addSubview(newNode.nodeObj())
                    flag = true
                    break
                }
                else if newNode.nodeObj().frame.equalTo(nodeList[index].nodeObj().frame){
                    print("NODE IS EQUAL")
                    break
                }
            }
            print("exiting for loop......")
            
        }
    }
}
*/
