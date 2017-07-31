//
//  HubController.swift
//  ProjectNode
//
//  Created by Jeffrey Weng on 7/27/17.
//  Copyright © 2017 Jeffrey Weng. All rights reserved.
//

import Foundation
import UIKit

class HubController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,ProjectCreatorDelegate{

    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    var collectionView: UICollectionView!
    var nodeProjects : [NodeProject] = []
    //var cellCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        //changes collection view size
        let frame = CGRect(x: 0, y: navBar.bounds.height,width: self.view.frame.width, height: self.view.frame.height - navBar.bounds.height)
        
        //defines cell placement
        //layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        //changes cell size
        layout.itemSize = CGSize(width: self.view.frame.width, height: 200)
        
        //creates the collectionview
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ProjectCell.self, forCellWithReuseIdentifier: "Cell")
        
        //sets background color
        collectionView.backgroundColor = UIColor.white
        //adds collection view

        self.view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraints = collectionView.topAnchor.constraint(equalTo: navBar.bottomAnchor)
        let bottomConstraints = collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        let leftConstraints = collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        let rightConstraints = collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        
        self.view.addConstraints([topConstraints, bottomConstraints, leftConstraints, rightConstraints])
        
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask(rawValue: UInt(Int(UIInterfaceOrientationMask.portrait.rawValue)))
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let ProjectCreator = segue.destination as? ProjectCreator{
            ProjectCreator.delegate = self
        }
        
    }
    
    func formCompleted(nameProject : String?, tag: Int?) {
        collectionView.reloadData()
        let node = NodeProject()
        node.projectName = nameProject
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
        nodeProjects.append(node)
    }

    
    
    //EXPERIMENT WITH THIS LATER
    
    /*
    override func viewDidLayoutSubviews() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        //changes collection view size
        let frame = CGRect(x: 0, y: navBar.bounds.height + self.topLayoutGuide.length,width: self.view.frame.width, height: self.view.frame.height - navBar.bounds.height - self.topLayoutGuide.length)
        
        //defines cell placement
        //layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        //changes cell size
        layout.itemSize = CGSize(width: self.view.frame.width, height: 200)
        
        //creates the collectionview
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(projectCell.self, forCellWithReuseIdentifier: "Cell")
        
        //sets background color
        collectionView.backgroundColor = UIColor.white
        //adds collection view
        collectionView.tag = -10
        for value in self.view.subviews{
            if value.tag == -10{
                value.removeFromSuperview()
            }
        }
        self.view.addSubview(collectionView)
    }
    */
    
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
        //cell.backgroundColor = UIColor.red
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        //collectionView.reloadData()
        //print(value)
    }
}



