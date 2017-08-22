//
//  ProjectCell.swift
//  ProjectNode
//
//  Created by Jeffrey Weng on 7/31/17.
//  Copyright © 2017 Jeffrey Weng. All rights reserved.
//

import Foundation
import UIKit

var selectedProject: NodeProject = NodeProject()

class BaseCell : UICollectionViewCell{
    override init(frame: CGRect){
        super.init(frame: frame)
        setupViews()

    }
    
    func setupViews(){
    
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init coder has not been implemented")
    }

}


class ProjectCell: BaseCell{
    
    
    
    var nodeProject : NodeProject? {
        didSet{
            nameLabel.text = nodeProject?.projectName
            tagView.backgroundColor = nodeProject?.chosenTag
            //Change project preview, tag
            
            //Project Preview Updation
            projectPreview.setImage(nodeProject?.projectPreviewImage, for: .normal)
            nodeProject?.projectPreviewButton = projectPreview
            dateLabel.text = nodeProject?.projectDate
            
        }
    }

 
    
    //NAME OF PROJECT
    let nameLabel: UILabel = {
        let labelView = UILabel()
        labelView.translatesAutoresizingMaskIntoConstraints = false
        labelView.text = ""
        
        return labelView
    }()
    
    //GET CURRENT DATE
    let dateLabel: UILabel = {
        let dateView = UILabel()
        dateView.translatesAutoresizingMaskIntoConstraints = false

        dateView.text = ""
        dateView.textAlignment = NSTextAlignment.right
        
        return dateView
    }()
    
    
    
    
    //GET PROJECT PREVIEW, SNAPSHOTS
    
    
    let projectPreview: UIButton = {
        let preview = UIButton()
        preview.translatesAutoresizingMaskIntoConstraints = false
        preview.imageView?.contentMode = UIViewContentMode.scaleAspectFill
        preview.imageView?.backgroundColor = UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 1)
        //preview.contentMode = .scaleAspectFill
        //preview.imageView?.clipsToBounds = true
        //preview.clipsToBounds = true
        //preview.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        //preview.imageView?.layer.cornerRadius = 15
        //return preview
        return preview
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //UPDATE COLLABORATOR COUNT BASED ON ADDED PEOPLE
   /* let memberLabel : UILabel = {
        let memberView = UILabel()
        // memberView.backgroundColor = UIColor.yellow
        memberView.translatesAutoresizingMaskIntoConstraints = false
        
        memberView.text = "Collaborators: 0"
        memberView.textColor = UIColor.black
        return memberView
    }()*/
    
    //SORT BY TAGS
    let tagView : UIImageView = {
        let tagV = UIImageView()
        tagV.backgroundColor = UIColor.red
        tagV.translatesAutoresizingMaskIntoConstraints = false
        //tagV.layer.cornerRadius = 7.5
        return tagV
    }()
    
    
    func previewTapped(sender: UIButton!) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "previewTappedNotification"), object: nil)
        //Update Selected Projects Button, for Preview
        selectedProject.projectPreviewButton = sender
    }
  
    
    override func setupViews(){
        //backgroundColor = UIColor.blue
        
        
        projectPreview.addTarget(self, action: #selector(previewTapped), for: .touchUpInside)
        projectPreview.backgroundColor = UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 1)
        
        addSubview(projectPreview)
        //addSubview(separatorView)
        addSubview(nameLabel)
        addSubview(dateLabel)
        //addSubview(memberLabel)
        //addSubview(tagView)
        
        
        addConstraintsWithFormat(format: "H:|-0-[v0]-0-|", views: projectPreview)
        addConstraintsWithFormat(format: "V:|-0-[v0]-36-|", views: projectPreview)
        //addConstraintsWithFormat(format: "H:|[v0]|", views: separatorView)
        
        
       /* addConstraintsWithFormat(format: "H:|-0-[v0]-0-|", views: projectPreview)
        addConstraintsWithFormat(format: "V:|-0-[v0]-36-[v1(1)]|", views: projectPreview,separatorView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: separatorView)*/
        
        //memberLabel
        /*
        //top constraint
        addConstraint(NSLayoutConstraint(item: memberLabel, attribute: .top, relatedBy: .equal, toItem: projectPreview, attribute: .top, multiplier: 1, constant: 0))
        //right constraint
        addConstraint(NSLayoutConstraint(item: memberLabel, attribute: .right, relatedBy: .equal, toItem: projectPreview, attribute: .centerX, multiplier: 1, constant: 0))
        
        //left constraint
        addConstraint(NSLayoutConstraint(item: memberLabel, attribute: .left, relatedBy: .equal, toItem: projectPreview, attribute: .left, multiplier: 1, constant: 0))
        
        //height constraint
        addConstraint(NSLayoutConstraint(item: memberLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 15))
        */
        //tagView
        /*
        addConstraint(NSLayoutConstraint(item: tagView, attribute: .top, relatedBy: .equal, toItem: projectPreview, attribute: .top, multiplier: 1, constant: 0))
        //right constraint
        addConstraint(NSLayoutConstraint(item: tagView, attribute: .right, relatedBy: .equal, toItem: projectPreview, attribute: .right, multiplier: 1, constant: 0))
        
        //left constraint
        addConstraint(NSLayoutConstraint(item: tagView, attribute: .left, relatedBy: .equal, toItem: projectPreview, attribute: .right, multiplier: 1, constant: -15))
        
        //height constraint
        addConstraint(NSLayoutConstraint(item: tagView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 15))
        */
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


