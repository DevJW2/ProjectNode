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
    //properties
    var distance: Double
    var color: UIColor
    var size: Double
    var name: String
    var nodeLimit: Int = 0
    
    var node: UIButton?
    
    //for the creation of the first node 
    init(_distance: Double, _color: UIColor, _size: Double, _name: String, _xCoordinate : Double, _yCoordinate: Double){
        distance = _distance
        color = _color
        size = _size
        name = _name
        
        node = UIButton(frame: CGRect(x: _xCoordinate, y: _yCoordinate, width: size, height: size))
        
        //More Node properties
        node!.layer.cornerRadius = CGFloat(size/2.0)
        node!.layer.backgroundColor = UIColor.blue.cgColor

    }
    
    
    init(_distance: Double, _color: UIColor, _size: Double, _name: String){
        distance = _distance
        color = _color
        size = _size
        name = _name
        
        //generate angles
        let randomAngle = Double(arc4random_uniform(361))
        
        //Generate locations based off angles
        let xCoordinate = distance * cos(randomAngle * (Double.pi / 180)) + Double(selectedNode!.getNode().frame.origin.x)
        let yCoordinate = distance * sin(randomAngle * (Double.pi / 180)) + Double(selectedNode!.getNode().frame.origin.y)
        
        node = UIButton(frame: CGRect(x: xCoordinate, y: yCoordinate, width: size, height: size))
        
        //More Node properties
        node!.layer.cornerRadius = CGFloat(size/2.0)
        node!.layer.backgroundColor = UIColor.blue.cgColor
        
        
    }
    
    func getLimit() -> Int{
        return nodeLimit
    }
    
    
    func getNode() -> UIButton{
        node!.addTarget(self, action: #selector(nodeSelection), for: .touchUpInside)
        return node!
    }
    
    func updateNodes(){
        
    }
    //Selects current node and highlights it for editing/movement/adding
    func nodeSelection(){
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "selectedNodeNotification"), object: nil)
        selectedNode = self
        selectedNode!.getNode().backgroundColor = UIColor.red
    }
    
    


}


/*   Previous Code
 
     var locationX : CGFloat?
     var locationY : CGFloat?
     
     let randomLocation = Int(arc4random_uniform(3))
     
     let rectSize = CGSize(width: distance * 2, height: distance * 2)
     //later on the center point will be the selected node
     let centerPoint = CGPoint(x : Int(UIScreen.main.bounds.width/2) - Int(rectSize.width/2),y : Int(UIScreen.main.bounds.height/2) - Int(rectSize.height/2))
     
     let tempRect = CGRect(origin: centerPoint, size: rectSize)
     //var allLocation : [CGPoint] = [CGPoint(x: tempRect.maxX, y: tempRect.maxY), CGPoint(x: tempRect.minX - size, y:tempRect.max), CGPoint(x: tempRect.midX - size/2, y:tempRect.minY - size)]
     
     if randomLocation == 0{
         locationX = tempRect.maxX
         locationY = tempRect.maxY
     }
     else if randomLocation == 1{
         locationX = tempRect.minX - size
         locationY = tempRect.maxY
     }
     else if randomLocation == 2{
         locationX = tempRect.midX - size/2
         locationY = tempRect.minY - size
     }
 */






