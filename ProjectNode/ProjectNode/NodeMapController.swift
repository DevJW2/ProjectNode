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
    var buttonCenter = CGPoint.zero
    var newNode : Node?

    override func viewDidLoad() {
        super.viewDidLoad()
    
        print("first node")
        let ancestorNode = Node(_distance: 50, _color: UIColor.blue, _size: 20, _name: "Hello World", _xCoordinate: Double(UIScreen.main.bounds.width/2), _yCoordinate: Double(UIScreen.main.bounds.height/2))
        print("Node: \(ancestorNode)")
        print("append first node to list")
        nodeList.append(ancestorNode)
        print("nodeList : \(nodeList)")
        print("add node to subview")
        self.view.addSubview(ancestorNode.getNode())
        print("node Object: \(ancestorNode.getNode())")
        print("received notification from node object for pan")
        NotificationCenter.default.addObserver(self, selector: #selector(nodeSelected), name: NSNotification.Name(rawValue: "nodeSelectedNotification"), object: nil)
        
    }
    @IBAction func nodeCreatorTapped(_ sender: Any) {
        print("start node creator tapped")
        if selectedNode!.getLimit() < 3{
            print("selected node is less than 3: \(selectedNode!.getLimit())")
            print("selected node: \(selectedNode!)")
            print("creating new node....")
            newNode = Node(_distance: 50, _color: UIColor.blue, _size: 20, _name: "Hello World")
            print("new node: \(newNode!)")
            nodeList.append(newNode!)
            print("append A NODE to list")
            print("node list: \(nodeList)")
            self.view.addSubview(newNode!.getNode())
            selectedNode!.nodeLimit += 1
            print("set the new node's connected node to the selected node")
            newNode?.setConnectedNode(item: selectedNode!)
            print("connected Node: \(newNode!.getConnectedNode())")
            print("connected node should be equal to selected node")
            print("create connection between selected node and the new node created")
            print("selectedNode: \(selectedNode!) and newNode: \(newNode!)")
            //createNodeConnection(selectNode: selectedNode!, createdNode: newNode!)
            createNodeConnection(selectNode: newNode!, createdNode: selectedNode!)
 
            print("end node creator tapped")
        }
        else{
            print("can't print any more nodes")
        }
        
    }
    
    func nodeSelected(){
        print("node is selected, nodeSelected function in nodeMap is called")
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panNode))
        selectedNode!.getNode().addGestureRecognizer(pan)
        print("setting pan to node")
        print("selectedNode: \(selectedNode!)")
    }

    func panNode(pan: UIPanGestureRecognizer){
        
        
        
        if pan.state == .began {
            print("pan state begin")
            buttonCenter = selectedNode!.getNode().center // store old button center
        } else if pan.state == .ended || pan.state == .failed || pan.state == .cancelled {
            print("pan state end")
            //selectedNode!.getNode().center = buttonCenter // restore button center
            
        } else {
            print("pan state still moving")
            let location = pan.location(in: view) // get pan location
            selectedNode!.getNode().center = location // set button to where finger is
            print("selectedNode that is moving: \(selectedNode!)")
            
            /*
            selectedNode?.removePath()
            selectedNode?.connectedNode?.removePath()
             */
            print("removing the connector lines")
            print("removing connector lines from selectedNode! ")
            print("selectedNode: \(selectedNode!)")
            selectedNode?.removeConnector()
            print("removing the connector lines from the parent connected node lines")
            print("parent node of the selected node: \(selectedNode!.getConnectedNode())")
            //selectedNode!.getConnectedNode().removeConnector()
            
            print("create new connection between selectedNode and selectedNode and connected Node")
            createNodeConnection(selectNode: selectedNode!, createdNode: selectedNode!.getConnectedNode())
            //createNodeConnection(selectNode: selectedNode!.getConnectedNode(), createdNode: selectedNode!)
            print("selectedNode: \(selectedNode!) and parent\(selectedNode!.getConnectedNode())")
            
            
        
        }
    }
    
    
    //remove previous lines
    //initial node has no node connection
    //moving root node connections must have other nod  es update their connections
    

    
    func createNodeConnection(selectNode : Node, createdNode: Node){
        let selectedNodeOrigin : CGPoint = CGPoint(x: Double(selectNode.getNode().frame.origin.x) + selectNode.size/2, y: Double(selectNode.getNode().frame.origin.y) + selectNode.size/2)
        let createdNodeOrigin : CGPoint = CGPoint(x : Double(createdNode.getNode().frame.origin.x) + createdNode.size/2, y: Double(createdNode.getNode().frame.origin.y) + createdNode.size/2)
        let path = UIBezierPath()
        path.move(to: selectedNodeOrigin)
        path.addLine(to: createdNodeOrigin)
        //selectedNode.addPath(path: path)
        //print(path)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 1.0
        
        
        self.view.layer.addSublayer(shapeLayer)
        print("adding connector, the line, to selectedNode")
        print("selectedNode: \(selectNode)")
        print("createdNode: \(createdNode)")
        print("shapeLayer: \(shapeLayer)")
        selectNode.addConnector(line: shapeLayer)
        //self.view.layer.insertSublayer(shapeLayer, below: selectedNode.getNode().layer)
        self.view.layer.insertSublayer(shapeLayer, at: 0)
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
