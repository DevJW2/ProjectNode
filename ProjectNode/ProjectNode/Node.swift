//
//  Node.swift
//  ProjectNode
//
//  Created by Jeffrey Weng on 7/31/17.
//  Copyright © 2017 Jeffrey Weng. All rights reserved.
//

import Foundation
import UIKit

class Node : NSObject{
    
    //Node Properties
    var distance: Double // UPDATE
    var color: UIColor //UPDATE
    var borderColor: UIColor = UIColor.white //UPDATE
    var previousBorderColor: UIColor = UIColor.white //Has to be the same as borderColor //UPDATE
    var size: Double
    var name: String //UPDATE
    var childNodes: Int = 0 //UPDATE
    var nodeLimit: Int //UPDATE
    var descript: String //UPDATE
    var node: UIButton?
    var connector: CAShapeLayer? //UPDATE
    var path: UIBezierPath?
    var connectedNode : Node? //UPDATE
    var xCoord: Double //UPDATE
    var yCoord: Double //UPDATE
    
    
    //Creation of First Node
    init(_distance: Double, _color: UIColor, _size: Double, _name: String, _descript: String, _nodeLimit: Int, _xCoordinate : Double, _yCoordinate: Double){
        
        distance = _distance
        color = _color
        size = _size
        name = _name
        descript = _descript
        nodeLimit = _nodeLimit
        xCoord = _xCoordinate
        yCoord = _yCoordinate

        node = UIButton(frame: CGRect(x: _xCoordinate - size/2, y: _yCoordinate - size/2, width: size, height: size))
        
        //More Node properties
        node!.layer.cornerRadius = CGFloat(size/2.0)
        node!.layer.borderWidth = 1
        node!.layer.borderColor = UIColor.white.cgColor
        node!.layer.backgroundColor = color.cgColor
        node!.setTitle(name, for: UIControlState.normal)
        node!.titleLabel?.font = UIFont(name: "Times New Roman", size: 18)
    }
    
    //Creation of every other Node
    init(_distance: Double, _color: UIColor, _size: Double, _name: String, _descript: String, _nodeLimit: Int){
        distance = _distance
        color = _color
        size = _size
        name = _name
        descript = _descript
        nodeLimit = _nodeLimit
        
        //generate angles
        let randomAngle = Double(arc4random_uniform(361))
        
        //Generate locations based off angles
        let xCoordinate = distance * cos(randomAngle * (Double.pi / 180)) + Double(selectedNode!.getNode().frame.origin.x)
        let yCoordinate = distance * sin(randomAngle * (Double.pi / 180)) + Double(selectedNode!.getNode().frame.origin.y)
        
        xCoord = xCoordinate
        yCoord = yCoordinate
        
        node = UIButton(frame: CGRect(x: xCoordinate, y: yCoordinate, width: size, height: size))
        
        //More Node properties
        node!.layer.cornerRadius = CGFloat(size/2.0)
        node!.layer.borderWidth = 1
        node!.layer.borderColor = UIColor.white.cgColor
        node!.layer.backgroundColor = color.cgColor
        node!.setTitle(name, for: UIControlState.normal)
        node!.titleLabel?.font = UIFont(name: "Times New Roman", size: 18)
        
    }

    
    //Data about the parent node of each node
    func setConnectedNode(item: Node){
        connectedNode = item
    }
    
    func getConnectedNode() -> Node?{
        if connectedNode == nil{
            return nil
        }
        else{
            return connectedNode!
        }
    }
    
    //Data about the line connector
    func addConnector(line : CAShapeLayer){
        connector = line
    }
    
    func removeConnector(){
        if let legitConnector = connector {
            connector!.removeFromSuperlayer()
            
        }
    }
    
    //Data about the paths
    func addPaths(item: UIBezierPath){
        path = item
    }
    func removePath(){
        if let legitPath = path{
            path!.removeAllPoints()
        }
    }
    
    //Properties of a node that can be edited
    
    func getSize() -> Double{
        return size
    }
    
    func setDescription(text: String){
        descript = text
    }
    
    func setName(text: String){
        name = text
    }
    func getName() -> String{
        return name
    }
    
    func setColor(value: UIColor){
        color = value
    }
    
    func setBorderColor(value : UIColor){
        borderColor = value
    }
    func setPreviousBorderColor(value : UIColor){
        previousBorderColor = value
    }
    
    func setNodeLimit(value: Int){
        nodeLimit = value
    }
    
    func getNodeLimit() -> Int{
        return nodeLimit
    }
    
    
    
    //Limit of how many nodes can be connected to a parent node
    func getChildren() -> Int{
        return childNodes
    }
    
    //Sets up target action and returns the UIButton Object
    func getNode() -> UIButton{
        node!.addTarget(self, action: #selector(nodeSelection), for: .touchUpInside)
        return node!
    }
    
    //Selects current node and highlights it for editing/movement/adding
    func nodeSelection(){
        //set Previous selected Node to its original color
        if selectedNode != nil{
            selectedNode!.getNode().backgroundColor = selectedNode!.color
            selectedNode!.getNode().layer.borderColor = selectedNode!.borderColor.cgColor
        
        }

        //Set selectedNode to selected node, set color to red
        selectedNode = self
        //selectedNode!.getNode().backgroundColor = UIColor.red
        selectedNode!.getNode().layer.borderColor = UIColor.red.cgColor
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "nodeSelectedNotification"), object: nil)
    }
    
    //writes node Data
    
    var dictValue: [String: Any]{
        
        return [
            "nodeName" : name,
            "nodeDescription" : descript,
            "nodeLimit" : nodeLimit,
            "xCoordinate" : xCoord,
            "yCoordinate" : yCoord
        ]
        
    }
    


}
