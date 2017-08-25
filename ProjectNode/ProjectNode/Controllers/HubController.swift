//
//  HubController.swift
//  ProjectNode
//
//  Created by Jeffrey Weng on 7/27/17.
//  Copyright © 2017 Jeffrey Weng. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseAuthUI
import FirebaseDatabase

var nodeProjects : [NodeProject] = []
var cellProjects : [ProjectCell] = []

class HubController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,ProjectCreatorDelegate, UISearchBarDelegate{
    
    @IBOutlet weak var projectSearch: UISearchBar!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    var collectionView: UICollectionView!
    
    var ref: DatabaseReference?
    let cell = ProjectCell()
    
    let collectionColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        //changes collection view size
        let frame = CGRect(x: 0, y: navBar.bounds.height,width: self.view.frame.width, height: self.view.frame.height - navBar.bounds.height)
        
        //defines cell placement
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        
        //changes cell size
        layout.itemSize = CGSize(width: self.view.frame.width - 10, height: 200)
        
        //creates the collectionview
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ProjectCell.self, forCellWithReuseIdentifier: "Cell")
        
        //sets background color
        collectionView.backgroundColor = collectionColor
        //adds collection view
        
        self.view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraints = collectionView.topAnchor.constraint(equalTo: navBar.bottomAnchor)
        let bottomConstraints = collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        let leftConstraints = collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        let rightConstraints = collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        
        self.view.addConstraints([topConstraints, bottomConstraints, leftConstraints, rightConstraints])
        
        NotificationCenter.default.addObserver(self, selector: #selector(previewTapped), name: NSNotification.Name(rawValue: "previewTappedNotification"), object: nil)
        
        ref = Database.database().reference()
        
        //Snapshotting retrieval
        
        //THIS ONLY WORKS IF THERE IS PROJECTS THERE, YOUR GOING TO HAVE TO EITHER SET A PROJECT THERE OR TESTING IF THERE IS PROJECTS THERE IN THE FIRST PLACE
        //YOU NEED TO ALSO BE ABLE TO DELETE PROJECTS....
       retrieveData()
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let ProjectCreator = segue.destination as? ProjectCreator{
            ProjectCreator.delegate = self
        }
        
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask(rawValue: UInt(Int(UIInterfaceOrientationMask.portrait.rawValue)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //retrievingService.updateProject()
        collectionView.reloadData()
    
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        collectionView.reloadData()
    }
    
    // THIS IS IMPORTANT FOR CHANGING DATA FOR THE HUB PROJECTS
    //Setting names and Tags
    /*
     func formCompleted(nameProject : String?, tag: Int?) {
     collectionView.reloadData()
     let node = NodeProject()
     //Project Name Updated
     node.projectName = nameProject
     //Tag Selection
     if tag == 0{
     node.chosenTag = UIColor.red
     }
     else if tag == 1{
     node.chosenTag = UIColor.yellow
     }
     else if tag == 2{
     node.chosenTag = UIColor.green
     }
     else if tag == 3{
     node.chosenTag = UIColor.blue
     }
     
     //Add Projects To Hub
     nodeProjects.append(node)
     }*/
    func formCompleted(nameproject: String?, dateCreated: String?) {
        collectionView.reloadData()
        
        
        
        
        let node = NodeProject()
        //Project Name Updated
        node.projectName = nameproject
        node.projectDate = dateCreated
        
        
        let cellProjectPreview = cell.projectPreview
        
        //FIREBASE
        
        //node.projectPreviewButton = cellProjectPreview
       
        
        let user = Auth.auth().currentUser
        if let user = user{
            
            let rootref = Database.database().reference()
            let newProjectRef = rootref.child("projects").child(user.uid).childByAutoId()
            
            node.specificKey = newProjectRef.key
            
            newProjectRef.updateChildValues(node.dictValue)
           
        }
        
        
        nodeProjects.append(node)
        
    }
    //UPDATE INSTEAD OF ADD
    func retrieveData(){
        collectionView.reloadData()
        retrievingService.obtainProject()
    }
    
    
    
    
    func previewTapped(){
        let storyboard = UIStoryboard(name: "LayoutEditor", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "nodePage")
        self.present(vc, animated: true, completion: nil)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //defines how many cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nodeProjects.count
    }
    //defines cell properties
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! ProjectCell
        cell.nodeProject = nodeProjects[indexPath.item]
        cell.backgroundColor = UIColor.white
        
        /*for item in nodeProjects{
         print(item.projectPreviewButton)
         }*/
        
        //cell.layer.borderColor = UIColor(red: 51/255,green: 153/255,blue: 255/255, alpha: 1).cgColor
        //cell.layer.borderWidth = 2
        //cell.backgroundColor = UIColor.red
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
    }
    
    
}

//old codeee
/*
 
 //                            let myProjects = snapshot.value as
 //
 //                            for (key, anotherDict) in myProjects{
 //                                let anotherDict = anotherDict as! NSDictionary
 //
 //                                var image: UIImage?
 //                                if let url = NSURL(string: anotherDict["projectImage"] as! String) {
 //                                    if let data = NSData(contentsOf: url as URL) {
 //                                        image = UIImage(data: data as Data)
 //                                    }
 //                                }
 //
 //                                self.receiveNodeProjects(projectName: anotherDict["projectName"] as! String, projectDate: anotherDict["projectDate"] as! String, projectImage: image!, projectImageURL: anotherDict["projectImage"] as! String, projectKey: anotherDict["projectStorageImageKey"] as! String, storageKey: key as! String)
 //
 //                            }
 */




