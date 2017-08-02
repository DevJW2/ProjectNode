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
    var distance: Int
    var color: UIColor
    var size: CGFloat
    var name: String
    
    init(_distance: Int, _color: UIColor, _size: CGFloat, _name: String){
        distance = _distance
        color = _color
        size = _size
        name = _name
        
    }
    
    func distanceFormula(x : Double, y : Double, _x : Double, _y : Double) -> Double{
        return sqrt(pow((x - y),2) + pow((_x - _y),2))
    }
    
    func nodeObj() -> UIButton{
        
        var locationX : CGFloat?
        var locationY : CGFloat?
        
        let randomLocation = Int(arc4random_uniform(3))
        
        let rectSize = CGSize(width: distance * 2, height: distance * 2)
        //later on the center point will be the selected node
        let centerPoint = CGPoint(x : Int(UIScreen.main.bounds.width/2) - Int(rectSize.width/2),y : Int(UIScreen.main.bounds.height/2) - Int(rectSize.height/2))
        
        let tempRect = CGRect(origin: centerPoint, size: rectSize)
        
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
        
        let node = UIButton(frame: CGRect(x: locationX!, y: locationY!, width: size, height: size))
        node.layer.cornerRadius = size/2
        node.backgroundColor = .black
        //button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return node
    }
    
    func updateNodes(){
    
    }
    
    
    


}
