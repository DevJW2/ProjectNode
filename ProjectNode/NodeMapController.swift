//
//  NodeMapController.swift
//  ProjectNode
//
//  Created by Jeffrey Weng on 7/31/17.
//  Copyright © 2017 Jeffrey Weng. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuthUI

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
    
    //let nodeColor = UIColor(red: 153/255, green: 204/255, blue: 255/255, alpha: 1)
    let nodeColor = UIColor(red: 51/255, green: 153/255, blue: 255/255, alpha: 1)
    
    let pinchRec = UIPinchGestureRecognizer()
    let panRec = UIPanGestureRecognizer()
    let rotateRec = UIRotationGestureRecognizer()
    
    //let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
    
    let canvas = UIView(frame: CGRect(x: 0, y:0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    let zoomMaxWidth : CGFloat = UIScreen.main.bounds.width * 3.0
    let zoomMinWidth : CGFloat = 50.0
    
    let ref: DatabaseReference = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //canvas.backgroundColor = UIColor.green
        self.view.addSubview(canvas)
        self.view.insertSubview(canvas, at: 0)
        
        let ancestorNode = Node(_distance: 100, _color: nodeColor, _size: nodeSize, _name: "Hi!", _descript: "", _nodeLimit: 3, _xCoordinate: Double(UIScreen.main.bounds.width/2), _yCoordinate: Double(UIScreen.main.bounds.height/2))

        nodeList.append(ancestorNode)
        ancestorNode.getNode().tag = -99
        canvas.addSubview(ancestorNode.getNode())
        //canvas.backgroundColor = UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 1)
        //canvas.layer.borderWidth = 1
        //canvas.layer.borderColor = UIColor.white.cgColor

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
        //addObtainedNodeToView()
    
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //obtainNode()
    }
    
    
    
    func obtainNode(){
        var nodeThere = false
        
        if let user = Auth.auth().currentUser{
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let key = snap.key
                    let value = snap.value
                    //print("key = \(key)  value = \(value!)")
                    
                    if key == "node"{
                        nodeThere = true
                    }
                }
            })
            
            if nodeThere{
            
                ref.child("nodes").child((getCurrentSelectedProject()?.specificKey)!).observeSingleEvent(of: .value, with: {(snapshot)
                    in
                   
        
                    guard let myNodeSnapshots = snapshot.children.allObjects as? [DataSnapshot],
                    let myKey = snapshot.key as? String else {
                        return
                    }
                    
                    for nodeSnapshots in myNodeSnapshots{
                        if myKey == self.getCurrentSelectedProject()?.specificKey{
                        
                            let nodeDict = nodeSnapshots.value as? [String: Any]
                            let nodeName = nodeDict?["nodeName"] as? String
                            let nodeDescription = nodeDict?["nodeDescription"] as? String
                            let nodeLimit = nodeDict?["nodeLimit"] as? Int
                            let xCoordinate = nodeDict?["xCoordinate"] as? Double
                            let yCoordinate = nodeDict?["yCoordinate"] as? Double
                            let color = nodeDict?["hexColor"] as? String
                            let borderColor = nodeDict?["borderColor"] as? String
                            let previousBorderColor = nodeDict?["previousBorderColor"] as? String
                            let childNodes = nodeDict?["childNodes"] as? Int
                            let tag = nodeDict?["tag"] as? Int
                            let connectedNodeProperties = nodeDict?["connectedNode"] as? [String: Any]
                            
                            self.createObtainedNode(nodeName: nodeName!, nodeDescription: nodeDescription!, nodeLimit: nodeLimit!, xCoordinate: xCoordinate!, yCoordinate: yCoordinate!, color: color!, borderColor: borderColor!, previousBorderColor: previousBorderColor!, childNodes: childNodes!, tag: tag!, connectedNodeProperties: connectedNodeProperties)
                            
                            
                        }
                        
                    }
                    
                })
            }
            else{
                print("node not there")
            }
            }
    
    }
    //Everytime it loads back in... it'll create more nodes, instead try making it update instead of add
    
    func createObtainedNode(nodeName: String, nodeDescription: String, nodeLimit: Int, xCoordinate: Double, yCoordinate: Double, color: String, borderColor: String, previousBorderColor: String, childNodes: Int, tag: Int, connectedNodeProperties: [String: Any]?){
        /*let ancestorNode = Node(_distance: 100, _color: nodeColor, _size: nodeSize, _name: "Hi!", _descript: "", _nodeLimit: 3, _xCoordinate: Double(UIScreen.main.bounds.width/2), _yCoordinate: Double(UIScreen.main.bounds.height/2))*/
        
        
        let node = Node(_distance: 100, _color: hexStringToUIColor(hex: color), _size: 50, _name: nodeName, _descript: nodeDescription, _nodeLimit: nodeLimit, _xCoordinate: xCoordinate, _yCoordinate: yCoordinate)
        
        node.setBorderColor(value: hexStringToUIColor(hex: borderColor))
        node.setPreviousBorderColor(value: hexStringToUIColor(hex: previousBorderColor))
        node.childNodes = childNodes
        node.getNode().tag = tag
        
        
        //set properties
        let connectedNodeColor = connectedNodeProperties?["hexColor"] as? String
        let connectedNodeName = connectedNodeProperties?["nodeName"] as? String
        let connectedNodeDescription = connectedNodeProperties?["nodeDescription"] as? String
        let connectedNodeLimit = connectedNodeProperties?["nodeLimit"] as? Int
        let connectedXCoordinate = connectedNodeProperties?["xCoordinate"] as? Double
        let connectedYCoordinate = connectedNodeProperties?["yCoordinate"] as? Double
        let connectedBorderColor = connectedNodeProperties?["borderColor"] as? String
        let connectedPreviousBorderColor = connectedNodeProperties?["previousBorderColor"] as? String
        let connectedChildNodes = connectedNodeProperties?["childNodes"] as? Int
        let connectedTag = connectedNodeProperties?["tag"] as? Int
        
        
    
        //Create connected Node
        if connectedNodeProperties != nil{
        
            let connectedNode = Node(_distance: 100, _color: hexStringToUIColor(hex: connectedNodeColor!), _size: 50, _name: connectedNodeName!, _descript: connectedNodeDescription!, _nodeLimit: connectedNodeLimit!, _xCoordinate: connectedXCoordinate!, _yCoordinate: connectedYCoordinate!)
            
            connectedNode.setBorderColor(value: hexStringToUIColor(hex: connectedBorderColor!))
            connectedNode.setPreviousBorderColor(value: hexStringToUIColor(hex: connectedPreviousBorderColor!))
            connectedNode.childNodes = connectedChildNodes!
            connectedNode.getNode().tag = connectedTag!
                
                 node.setConnectedNode(item: connectedNode)
        }
        
        

        
    
       /* if node.getNode().tag == -99{
            selectedNode = node
        } */
        
        nodeList.append(node)
        
        //canvas.addSubview(node.getNode())
    }
    
    func addObtainedNodeToView(){
        /*nodeList.append(newNode!)
        
        canvas.addSubview(newNode!.getNode())
        selectedNode!.childNodes += 1
        
        newNode?.setConnectedNode(item: selectedNode!)
        
        //createNodeConnection(selectNode: selectedNode!, createdNode: newNode!)
        canvas.insertSubview(newNode!.getNode(), belowSubview: nodeCreator)
        createNodeConnection(selectNode: newNode!, createdNode: selectedNode!)*/
        obtainNode()
        print("node list")
        print(nodeList)
        
        for node in nodeList{
            canvas.addSubview(node.getNode())
            for connected in nodeList{
                print("This is the node outside")
                print(node)
                print("These are the nodes being compared to inside")
                print(connected)
                
                if node == connected.connectedNode{
                    print("They printed out to be true")
                    createNodeConnection(selectNode: node, createdNode: connected)
                }
            }
        }
        
    }
    
    
    
    
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask(rawValue: UInt(Int(UIInterfaceOrientationMask.portrait.rawValue)))
    }
    @IBAction func backHubTapped(_ sender: Any) {
        let image = takeScreenShotImage()

        if getCurrentSelectedProject()?.previewImageURL == nil{
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("\(imageName).png")
        
            StorageService.uploadImage(image, at: storageRef) { (downloadURL) in
                guard let downloadURL = downloadURL else {
                    return
                }
        
                let urlString = downloadURL.absoluteString
                //print("image url: \(urlString)")
                self.updateFormURL(previewImageURL: urlString)
                
            }
            getCurrentSelectedProject()?.currentImageName = imageName
        }
        else{
            let storageRef = Storage.storage().reference().child("\(getCurrentSelectedProject()!.currentImageName!).png")
            StorageService.uploadImage(image, at: storageRef){ (downloadURL)
            in
                guard let downloadURL = downloadURL else {
                    return
                }
            
                let urlString = downloadURL.absoluteString
                //print("image url: \(urlString)")
                self.updateFormURL(previewImageURL: urlString)
            }
            
        }
        self.updateForm(projectPreviewImage: image)
        //getCurrentSelectedProject()?.myNodes = self.nodeList
 
        /*
         if let uploadData = UIImagePNGRepresentation(projectPreviewImage){
         storageRef.putData(uploadData, metadata: nil, completion: {
            (metadata, error) in
                if error != nil{
                        print(error)
                        return
            }
         
                print(metaData)
         
            })
         }*/
        
        
        //Updates firebase for each node
        updateFirNode()
        
        //Works after you get the connections
        //removeNodes(node: nodeList[0])
        
        dismiss(animated: true, completion: nil)
    }
    
    func updateFirNode(){
        let rootref = Database.database().reference()
        let newNodeRef = rootref.child("nodes").child((getCurrentSelectedProject()?.specificKey)!)
        for node in nodeList{
            let randomNodeKey = NSUUID().uuidString
            newNodeRef.updateChildValues([randomNodeKey: node.dictValue])
        }
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
        print("image updation happened")
        for item in nodeProjects{
            if item.projectPreviewButton == selectedProject.projectPreviewButton{
                print(item.projectName)
                print(selectedProject.projectName)
                print("has been set equal and will now set preview image to image")
                item.projectPreviewImage = projectPreviewImage
            }
        }
    }
    func updateFormURL(previewImageURL: String?){
        print("UPDATING FORM URL")
        print("Print out all item buttons first")
        print("\n")
        for item in nodeProjects{
            print("item name: ")
            print(item.projectName)
            print("item button: ")
            print(item.projectPreviewButton)
            print("\n")
        }
        
        
        for item in nodeProjects{
            if item.projectPreviewButton == selectedProject.projectPreviewButton{
                print("In updating the form url........")
                print("the two items are now equal")
                print("item button")
                print(item.projectPreviewButton)
                print(item.projectName)
                print("selected project button")
                print(selectedProject.projectPreviewButton)
                print(selectedProject.projectName)
                print("\n")
                
                item.previewImageURL = previewImageURL
                
                let user = Auth.auth().currentUser
                if let user = user{
                    let rootref = Database.database().reference()
                    let newProjectRef = rootref.child("projects").child(user.uid).child(item.specificKey!)
                    
                    
                    newProjectRef.updateChildValues(item.dictValue)
                }
                
            }
        }
    }
  
    func getCurrentSelectedProject() -> NodeProject? {
        for item in nodeProjects{
            if item.projectPreviewButton == selectedProject.projectPreviewButton{
                return item
            }
        }
        return nil
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
            item.xCoord = Double(item.getNode().frame.origin.x)
            item.yCoord = Double(item.getNode().frame.origin.y)
        }
        totalTransformX += transformValueX
        totalTransformY += transformValueY
        updateNodeConnections()
    
    }
    
    func reverseNodePositions(){
        for item in nodeList{
            item.getNode().frame.origin.x -= totalTransformX
            item.getNode().frame.origin.y -= totalTransformY
            item.xCoord = Double(item.getNode().frame.origin.x)
            item.yCoord = Double(item.getNode().frame.origin.y)
        }
        totalTransformX = 0
        totalTransformY = 0
        updateNodeConnections()
    
    }
    
    func panNode(pan: UIPanGestureRecognizer){
        let location = pan.location(in: canvas) // get pan location
        if let selectedNode = selectedNode{
            selectedNode.getNode().center = location // set button to where finger is
            selectedNode.xCoord = Double(location.x)
            selectedNode.yCoord = Double(location.y)
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

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.characters.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
