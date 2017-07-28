//
//  HubController.swift
//  ProjectNode
//
//  Created by Jeffrey Weng on 7/27/17.
//  Copyright © 2017 Jeffrey Weng. All rights reserved.
//

import Foundation
import UIKit
class HubController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    var collectionView: UICollectionView!
    
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
        collectionView.register(projectCell.self, forCellWithReuseIdentifier: "Cell")
        
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
        return 5
    }
    //defines cell properties
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath)
        //cell.backgroundColor = UIColor.red
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    

    @IBAction func addButtonTapped(_ sender: Any) {
        
    }
}

class projectCell: UICollectionViewCell{
    override init(frame: CGRect){
        super.init(frame: frame)
        setupViews()
    }
    
    let nameLabel: UILabel = {
        let labelView = UILabel()
        //labelView.backgroundColor = UIColor.green
        labelView.translatesAutoresizingMaskIntoConstraints = false
        
        labelView.text = "Jeffrey Weng"
        return labelView
    }()
    
    let dateLabel: UILabel = {
        let dateView = UILabel()
       // dateView.backgroundColor = UIColor.purple
        dateView.translatesAutoresizingMaskIntoConstraints = false
        
        dateView.text = "7/28/2017"
        dateView.textAlignment = NSTextAlignment.right
        dateView.font = UIFont(name: "HelveticaNeue-UltraLight",
                                 size: 20.0)
        return dateView
    }()
    
    
    let projectPreview: UIImageView = {
        let preview = UIImageView()
       // preview.backgroundColor = UIColor.red
        preview.translatesAutoresizingMaskIntoConstraints = false
        //get image
        preview.image = UIImage(named: "projectNodeLogo")
        preview.contentMode = .scaleAspectFill
        preview.clipsToBounds = true
        return preview
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let memberLabel : UILabel = {
        let memberView = UILabel()
       // memberView.backgroundColor = UIColor.yellow
        memberView.translatesAutoresizingMaskIntoConstraints = false
        
        memberView.text = "Collaborators: 5"
        memberView.textColor = UIColor.white
        return memberView
    }()
    
    let tagView : UIImageView = {
        let tagV = UIImageView()
        tagV.backgroundColor = UIColor.red
        tagV.translatesAutoresizingMaskIntoConstraints = false
        tagV.layer.cornerRadius = 10
        return tagV
    }()
    
    func setupViews(){
        //backgroundColor = UIColor.blue
        addSubview(projectPreview)
        addSubview(separatorView)
        addSubview(nameLabel)
        addSubview(dateLabel)
        addSubview(memberLabel)
        addSubview(tagView)
        
        addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: projectPreview)
        addConstraintsWithFormat(format: "V:|-16-[v0]-36-[v1(1)]|", views: projectPreview,separatorView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: separatorView)
        
        //memberLabel
        
        //top constraint
        addConstraint(NSLayoutConstraint(item: memberLabel, attribute: .top, relatedBy: .equal, toItem: projectPreview, attribute: .top, multiplier: 1, constant: 0))
        //right constraint
        addConstraint(NSLayoutConstraint(item: memberLabel, attribute: .right, relatedBy: .equal, toItem: projectPreview, attribute: .centerX, multiplier: 1, constant: 0))
        
        //left constraint
        addConstraint(NSLayoutConstraint(item: memberLabel, attribute: .left, relatedBy: .equal, toItem: projectPreview, attribute: .left, multiplier: 1, constant: 0))
        
        //height constraint
        addConstraint(NSLayoutConstraint(item: memberLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 15))
        
        //tagView
        
        addConstraint(NSLayoutConstraint(item: tagView, attribute: .top, relatedBy: .equal, toItem: projectPreview, attribute: .top, multiplier: 1, constant: 0))
        //right constraint
        addConstraint(NSLayoutConstraint(item: tagView, attribute: .right, relatedBy: .equal, toItem: projectPreview, attribute: .right, multiplier: 1, constant: 0))
        
        //left constraint
        addConstraint(NSLayoutConstraint(item: tagView, attribute: .left, relatedBy: .equal, toItem: projectPreview, attribute: .right, multiplier: 1, constant: -15))
        
        //height constraint
        addConstraint(NSLayoutConstraint(item: tagView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 15))
        
        //nameLabel
        
        //top constraint
        addConstraint(NSLayoutConstraint(item: nameLabel, attribute: .top, relatedBy: .equal, toItem: projectPreview, attribute: .bottom, multiplier: 1, constant: 8))
        //right constraint
        addConstraint(NSLayoutConstraint(item: nameLabel, attribute: .right, relatedBy: .equal, toItem: projectPreview, attribute: .centerX, multiplier: 1, constant: 0))
        
        //left constraint 
        addConstraint(NSLayoutConstraint(item: nameLabel, attribute: .left, relatedBy: .equal, toItem: projectPreview, attribute: .left, multiplier: 1, constant: 0))
        
        //height constraint
        addConstraint(NSLayoutConstraint(item: nameLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 20))
        
        //dateLabel
        
        addConstraint(NSLayoutConstraint(item: dateLabel, attribute: .top, relatedBy: .equal, toItem: projectPreview, attribute: .bottom, multiplier: 1, constant: 8))
        //right constraint
        addConstraint(NSLayoutConstraint(item: dateLabel, attribute: .right, relatedBy: .equal, toItem: projectPreview, attribute: .right, multiplier: 1, constant: 0))
        
        //left constraint
        addConstraint(NSLayoutConstraint(item: dateLabel, attribute: .left, relatedBy: .equal, toItem: projectPreview, attribute: .centerX, multiplier: 1, constant: 0))
        
        //height constraint
        addConstraint(NSLayoutConstraint(item: dateLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 20))

        
       // addConstraintsWithFormat(format: "V:[v0(20)]", views: nameLabel)
       // addConstraintsWithFormat(format: "H:|[v0]|", views: nameLabel)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init coder has not been implemented")
    }

}
extension UIView{
    func addConstraintsWithFormat(format: String, views: UIView...){
        var viewsDictionary = [String: UIView]()
        for(index, view) in views.enumerated(){
            let key = "v\(index)"
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    
    }

}


