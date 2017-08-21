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
    
    
    var nodeList : [Node] = []
    var buttonCenter = CGPoint.zero
    var newNode : Node?
    var nodeSize : Double = 50.0
    
    var totalTransformX: CGFloat = 0
    var totalTransformY: CGFloat = 0
    
    let nodeColor = UIColor(red: 153/255, green: 204/255, blue: 255/255, alpha: 1)
    
    let pinchRec = UIPinchGestureRecognizer()
    let panRec = UIPanGestureRecognizer()
    let rotateRec = UIRotationGestureRecognizer()
    
    //let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
    
    let canvas = UIView(frame: CGRect(x: 0, y:0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    let zoomMaxWidth : CGFloat = UIScreen.main.bounds.width * 3.0
    let zoomMinWidth : CGFloat = 50.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //canvas.backgroundColor = UIColor.green
        self.view.addSubview(canvas)
        self.view.insertSubview(canvas, at: 0)
        
        let ancestorNode = Node(_distance: 100, _color: nodeColor, _size: nodeSize, _name: "Hi!", _descript: "", _nodeLimit: 3, _xCoordinate: Double(UIScreen.main.bounds.width/2), _yCoordinate: Double(UIScreen.main.bounds.height/2))

        nodeList.append(ancestorNode)
        ancestorNode.getNode().tag = -99
        canvas.addSubview(ancestorNode.getNode())
        //canvas.backgroundColor = UIColor.green

        NotificationCenter.default.addObserver(self, selector: #selector(nodeSelected), name: NSNotification.Name(rawValue: "nodeSelectedNotification"), object: nil)
        
        nodeCreator.isHidden = true
        editNode.isHidden = true
        deleteNode.isHidden = true
        
        //Moving the views around: Pinching, Panning, and Rotating
        
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
        
        //self.view.addGestureRecognizer(longPressRecognizer)
        
    
    }
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask(rawValue: UInt(Int(UIInterfaceOrientationMask.portrait.rawValue)))
    }
    @IBAction func backHubTapped(_ sender: Any) {
        updateForm(projectPreviewImage: takeScreenShotImage())
        selectedProject.myNodes = self.nodeList
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
        
        //updateNodeSize(transformScale: sender.scale)
        sender.scale = 1.0
    }
    
    func reversePinchedView(){
        canvas.frame.size.width = UIScreen.main.bounds.width
        canvas.frame.size.height = UIScreen.main.bounds.height
    }
    //Update Previews
    func updateForm(projectPreviewImage: UIImage?){
        for item in nodeProjects{
            if item.projectPreviewButton == selectedProject.projectPreviewButton{
                item.projectPreviewImage = projectPreviewImage
            }
        }
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

        if selectedNode!.getChildren() < selectedNode!.getNodeLimit(){

            newNode = Node(_distance: 100, _color: nodeColor, _size: nodeSize, _name: "", _descript: "", _nodeLimit: 3)

            nodeList.append(newNode!)

            canvas.addSubview(newNode!.getNode())
            selectedNode!.childNodes += 1

            newNode?.setConnectedNode(item: selectedNode!)
            
            //createNodeConnection(selectNode: selectedNode!, createdNode: newNode!)
            canvas.insertSubview(newNode!.getNode(), belowSubview: nodeCreator)
            createNodeConnection(selectNode: newNode!, createdNode: selectedNode!)
 
        }
        else{
            print("can't print any more nodes")
        }
        
    }
    
    @IBAction func editNodeTapped(_ sender: Any) {
        performSegue(withIdentifier: "nodeEdit", sender: nil)
    }
    //Removing Nodes
    @IBAction func deleteNodeTapped(_ sender: Any) {
        removeNodes(node: selectedNode!)
        
        nodeCreator.isHidden = true
        editNode.isHidden = true
        deleteNode.isHidden = true
        
        selectedNode!.connectedNode?.childNodes -= 1
        //print(nodeList)
    }
    
    func removeNodes(node: Node){
        //lessen the limit
        node.getNode().removeFromSuperview()
        node.removeConnector()
        nodeList.remove(at: nodeList.index(of: node)!)
        for item in nodeList{
            if item.connectedNode == node{
                removeNodes(node: item)
            }
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if let nodeEditor = segue.destination as? NodeEditorController{
            nodeEditor.delegate = self
        }
    }
    
//OBTAINING DATA HERE, FROM DELEGATE
    func nodeProperties(name: String, color: UIColor, size: Double) {
        print(name)
    }
    
    //When node is selected
    func nodeSelected(){
        if selectedNode!.getNode().tag == -99{
            nodeCreator.isHidden = false
            editNode.isHidden = false
            deleteNode.isHidden = true
        }
        else{
            deleteNode.isHidden = false
            nodeCreator.isHidden = false
            editNode.isHidden = false
        }
        

        let pan = UIPanGestureRecognizer(target: self, action: #selector(panNode))
        selectedNode!.getNode().addGestureRecognizer(pan)
        
    }
    
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
        totalTransformX += transformValueX
        totalTransformY += transformValueY
        updateNodeConnections()
    
    }
    
    func reverseNodePositions(){
        for item in nodeList{
            item.getNode().frame.origin.x -= totalTransformX
            item.getNode().frame.origin.y -= totalTransformY
        }
        totalTransformX = 0
        totalTransformY = 0
        updateNodeConnections()
    
    }
    
    func panNode(pan: UIPanGestureRecognizer){
        let location = pan.location(in: canvas) // get pan location
        if let selectedNode = selectedNode{
            selectedNode.getNode().center = location // set button to where finger is
            selectedNode.removeConnector()
        //selectedNode!.getConnectedNode().removeConnector()
        }
        
        updateNodeConnections()
    
    }
    
    
    
    func createNodeConnection(selectNode : Node, createdNode: Node){
        let selectedNodeOrigin : CGPoint = CGPoint(x: Double(selectNode.getNode().frame.origin.x) + selectNode.size/2, y: Double(selectNode.getNode().frame.origin.y) + selectNode.size/2)
        let createdNodeOrigin : CGPoint = CGPoint(x : Double(createdNode.getNode().frame.origin.x) + createdNode.size/2, y: Double(createdNode.getNode().frame.origin.y) + createdNode.size/2)
        let path = UIBezierPath()
        path.move(to: selectedNodeOrigin)
        path.addLine(to: createdNodeOrigin)
        selectNode.addPaths(item: path)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 1.0
        
        canvas.layer.addSublayer(shapeLayer)
        selectNode.addConnector(line: shapeLayer)
        canvas.layer.insertSublayer(shapeLayer, at: 0)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            if touch.view == canvas || touch.view == self.view{
                //set Previous selected Node to its original color
                if selectedNode != nil{
                    selectedNode!.getNode().backgroundColor = selectedNode!.color
                    selectedNode!.getNode().layer.borderColor = selectedNode!.borderColor.cgColor
                }
                selectedNode = nil
                nodeCreator.isHidden = true
                editNode.isHidden = true
                deleteNode.isHidden = true
            }
            else{
                return
            }
        }
    }
    
    func takeScreenShot() -> UIImageView{
        reverseNodePositions()
        UIGraphicsBeginImageContext(canvas.frame.size)
        canvas.layer.render(in: UIGraphicsGetCurrentContext()!)
        let snapshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let snapshotImageView = UIImageView(image: snapshotImage)
        snapshotImageView.frame = CGRect(x: 0,y: 0,width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        return snapshotImageView
    }
    
    func takeScreenShotImage() -> UIImage{
        reverseNodePositions()
        reversePinchedView()
        UIGraphicsBeginImageContext(canvas.frame.size)
        canvas.layer.render(in: UIGraphicsGetCurrentContext()!)
        let snapshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        //print(snapshotImage?.accessibilityIdentifier)
        return snapshotImage!
        
    
    }
    
    


}
