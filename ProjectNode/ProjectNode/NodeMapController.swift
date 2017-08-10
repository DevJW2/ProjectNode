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

class NodeMapController : UIViewController, NodeEditorControllerDelegate{
    @IBOutlet weak var nodeCreator: UIButton!
    @IBOutlet weak var editNode: UIButton!
    @IBOutlet weak var deleteNode: UIButton!
    @IBOutlet weak var backHub: UIButton!
    var nodeList : [Node] = [] //Has to be dictionary, each key contains an array of values[amount of nodes]
    var buttonCenter = CGPoint.zero
    var newNode : Node?
    var nodeSize : Double = 50.0
    
    let pinchRec = UIPinchGestureRecognizer()
    let panRec = UIPanGestureRecognizer()
    let rotateRec = UIRotationGestureRecognizer()
    
    let canvas = UIView(frame: CGRect(x: 0, y:0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    let zoomMaxWidth : CGFloat = UIScreen.main.bounds.width * 3.0
    let zoomMinWidth : CGFloat = 50.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //canvas.backgroundColor = UIColor.green
        self.view.addSubview(canvas)
        self.view.insertSubview(canvas, at: 0)
        
        print("first node")
        let ancestorNode = Node(_distance: 100, _color: UIColor.blue, _size: nodeSize, _name: "Hello", _descript: "", _xCoordinate: Double(UIScreen.main.bounds.width/2), _yCoordinate: Double(UIScreen.main.bounds.height/2))
        print("Node: \(ancestorNode)")
        print("append first node to list")
        nodeList.append(ancestorNode)
        print("nodeList : \(nodeList)")
        print("add node to subview")
        canvas.addSubview(ancestorNode.getNode())
        print("node Object: \(ancestorNode.getNode())")
        print("received notification from node object for pan")
        NotificationCenter.default.addObserver(self, selector: #selector(nodeSelected), name: NSNotification.Name(rawValue: "nodeSelectedNotification"), object: nil)
        
        nodeCreator.isHidden = true
        editNode.isHidden = true
        deleteNode.isHidden = true
        
        pinchRec.addTarget(self, action: #selector(pinchedView))
        canvas.addGestureRecognizer(pinchRec)
        canvas.isUserInteractionEnabled = true
        
        self.view.addGestureRecognizer(pinchRec)
        self.view.isUserInteractionEnabled = true
        
        panRec.addTarget(self, action: #selector(draggedView))
        canvas.addGestureRecognizer(panRec)
        canvas.isUserInteractionEnabled = true
        
        self.view.addGestureRecognizer(panRec)
        self.view.isUserInteractionEnabled = true
    
        
        rotateRec.addTarget(self, action: #selector(rotatedView))
        canvas.addGestureRecognizer(rotateRec)
        canvas.isUserInteractionEnabled = true
        
        self.view.addGestureRecognizer(rotateRec)
        self.view.isUserInteractionEnabled = true
        
        
    
    }
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask(rawValue: UInt(Int(UIInterfaceOrientationMask.portrait.rawValue)))
    }
    @IBAction func backHubTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
    func pinchedView(sender: UIPinchGestureRecognizer){
        if canvas.frame.size.width < zoomMaxWidth && canvas.frame.size.width > zoomMinWidth{
            canvas.transform = canvas.transform.scaledBy(x: sender.scale, y: sender.scale)
        }
        else if canvas.frame.size.width > zoomMaxWidth{
            if sender.scale < 1 {
                canvas.transform = canvas.transform.scaledBy(x: sender.scale, y: sender.scale)

            }
        }
        else if canvas.frame.size.width < zoomMinWidth {
            if sender.scale > 1{
                canvas.transform = canvas.transform.scaledBy(x: sender.scale, y: sender.scale)
            }
        }
        
        //self.view!.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        //updateNodeSize(transformScale: sender.scale)
        sender.scale = 1.0
    }
    
    
    func draggedView(sender: UIPanGestureRecognizer){
        let translation = sender.translation(in: canvas)
        //sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x, y: sender.view!.center.y + translation.y)
        updateNodePositions( transformValueX: translation.x, transformValueY: translation.y)
        sender.setTranslation(CGPoint.zero, in: canvas)
    }
    
    func rotatedView(sender: UIRotationGestureRecognizer){
        canvas.transform = canvas.transform.rotated(by: sender.rotation)
        sender.rotation = 0
    
    }
    
    @IBAction func nodeCreatorTapped(_ sender: Any) {
        print("start node creator tapped")
        if selectedNode!.getLimit() < 3{
            print("selected node is less than 3: \(selectedNode!.getLimit())")
            print("selected node: \(selectedNode!)")
            print("creating new node....")
            newNode = Node(_distance: 100, _color: UIColor.blue, _size: nodeSize, _name: "", _descript: "")
            print("new node: \(newNode!)")
            nodeList.append(newNode!)
            print("append A NODE to list")
            print("node list: \(nodeList)")
            canvas.addSubview(newNode!.getNode())
            selectedNode!.nodeLimit += 1
            print("set the new node's connected node to the selected node")
            newNode?.setConnectedNode(item: selectedNode!)
            print("connected Node: \(newNode!.getConnectedNode())")
            print("connected node should be equal to selected node")
            print("create connection between selected node and the new node created")
            print("selectedNode: \(selectedNode!) and newNode: \(newNode!)")
            //createNodeConnection(selectNode: selectedNode!, createdNode: newNode!)
            canvas.insertSubview(newNode!.getNode(), belowSubview: nodeCreator)
            createNodeConnection(selectNode: newNode!, createdNode: selectedNode!)
 
            print("end node creator tapped")
        }
        else{
            print("can't print any more nodes")
        }
        
    }
    
    @IBAction func editNodeTapped(_ sender: Any) {
        performSegue(withIdentifier: "nodeEdit", sender: nil)
    }
    
    @IBAction func deleteNodeTapped(_ sender: Any) {

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if let nodeEditor = segue.destination as? NodeEditorController{
            nodeEditor.delegate = self
        }
    }
    
//OBTAINING DATA HERE
    func nodeProperties(name: String, color: UIColor, size: Double) {
        print(name)
    }
    
    func nodeSelected(){
        nodeCreator.isHidden = false
        editNode.isHidden = false
        deleteNode.isHidden = false
        panRec.isEnabled = false
        print("node is selected, nodeSelected function in nodeMap is called")
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panNode))
        selectedNode!.getNode().addGestureRecognizer(pan)
        print("setting pan to node")
        print("selectedNode: \(selectedNode!)")
        
        
    }
    
   /* func updateNodes(){
        for item in 1..<nodeList.count{
            nodeList[item].removeConnector()
            createNodeConnection(selectNode: nodeList[item], createdNode: nodeList[item].getConnectedNode()!)
        }
    }*/
    
    //UPDATING PANNING/ROTATING/ZOOMING
    //Zooming - Changes Node Size, line width, line distance, all relative
    //panning - change x and y positions
    //rotating - change x and y positions
    
    
    func updateNodeConnections(){
        for item in nodeList{
            
            item.removeConnector()
            if item.getConnectedNode() == nil{
            }
            else{
            createNodeConnection(selectNode: item, createdNode: item.getConnectedNode()!)
            }
        }
    }
    
    func updateNodePositions(transformValueX: CGFloat, transformValueY: CGFloat){
        for item in nodeList{
            item.getNode().frame.origin.x += transformValueX
            item.getNode().frame.origin.y += transformValueY
        }
        updateNodeConnections()
    
    }
    
    /*func updateNodeSize(transformScale: CGFloat){
        for item in nodeList{
            item.getNode().transform = item.getNode().transform.scaledBy(x: transformScale, y: transformScale)
            if transformScale < 1.0{
                updateNodePositions(transformValueX: -1.0, transformValueY: -1.0)
            }
            else{
                updateNodePositions(transformValueX: 1.0, transformValueY: 1.0)
            }
            nodeSize = Double(item.getNode().frame.size.width)
            item.updateSize(value: nodeSize)
            
            
        }
        updateNodeConnections()
    }*/

    func panNode(pan: UIPanGestureRecognizer){
        if pan.state == .began {
            print("pan state begin")
            buttonCenter = selectedNode!.getNode().center // store old button center
        } else if pan.state == .ended || pan.state == .failed || pan.state == .cancelled {
            print("pan state end")
            //selectedNode!.getNode().center = buttonCenter // restore button center
            
        } else {
            print("pan state still moving")
            let location = pan.location(in: canvas) // get pan location
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
            //createNodeConnection(selectNode: selectedNode!, createdNode: selectedNode!.getConnectedNode())
            //createNodeConnection(selectNode: selectedNode!.getConnectedNode(), createdNode: selectedNode!)
            print("selectedNode: \(selectedNode!) and parent\(selectedNode!.getConnectedNode())")
            updateNodeConnections()
        
        }
    }
    
    
    
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
        //CGFloat(nodeSize/30.0) 30 is base circle size
        
        
        canvas.layer.addSublayer(shapeLayer)
        print("adding connector, the line, to selectedNode")
        print("selectedNode: \(selectNode)")
        print("createdNode: \(createdNode)")
        print("shapeLayer: \(shapeLayer)")
        selectNode.addConnector(line: shapeLayer)
        //self.view.layer.insertSublayer(shapeLayer, below: selectedNode.getNode().layer)
        canvas.layer.insertSublayer(shapeLayer, at: 0)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        if let touch = touches.first{
            if touch.view == canvas || touch.view == self.view{
                if selectedNode != nil{
                    selectedNode!.getNode().backgroundColor = selectedNode!.color
                }
                selectedNode = nil
                nodeCreator.isHidden = true
                editNode.isHidden = true
                deleteNode.isHidden = true
                panRec.isEnabled = true
            }
            else{
                return
            }
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
