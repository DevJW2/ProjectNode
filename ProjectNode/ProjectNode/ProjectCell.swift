//
//  ProjectCell.swift
//  ProjectNode
//
//  Created by Jeffrey Weng on 7/31/17.
//  Copyright © 2017 Jeffrey Weng. All rights reserved.
//

import Foundation
import UIKit

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
            //will change project preview, collaborators, tag
            
        }
    }
    
    //NAME OF PROJECT
    let nameLabel: UILabel = {
        let labelView = UILabel()
        //labelView.backgroundColor = UIColor.green
        labelView.translatesAutoresizingMaskIntoConstraints = false
        
        labelView.text = ""
        return labelView
    }()
    
    //GET CURRENT DATE
    let dateLabel: UILabel = {
        let dateView = UILabel()
        // dateView.backgroundColor = UIColor.purple
        dateView.translatesAutoresizingMaskIntoConstraints = false
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        dateView.text = "\(month)/\(day)/\(year)"
        dateView.textAlignment = NSTextAlignment.right
        return dateView
    }()
    
    //GET PROJECT PREVIEW, SNAPSHOTS
    let projectPreview: UIImageView = {
        let preview = UIImageView()
        // preview.backgroundColor = UIColor.red
        preview.translatesAutoresizingMaskIntoConstraints = false
        //get image
        preview.image = UIImage(named: "")
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
    //UPDATE COLLABORATOR COUNT BASED ON ADDED PEOPLE
    let memberLabel : UILabel = {
        let memberView = UILabel()
        // memberView.backgroundColor = UIColor.yellow
        memberView.translatesAutoresizingMaskIntoConstraints = false
        
        memberView.text = "Collaborators: 0"
        memberView.textColor = UIColor.black
        return memberView
    }()
    //SORT BY TAGS
    let tagView : UIImageView = {
        let tagV = UIImageView()
        tagV.backgroundColor = UIColor.red
        tagV.translatesAutoresizingMaskIntoConstraints = false
        tagV.layer.cornerRadius = 7.5
        return tagV
    }()
    
    override func setupViews(){
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
