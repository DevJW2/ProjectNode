//
//  NodeMapController.swift
//  ProjectNode
//
//  Created by Jeffrey Weng on 7/31/17.
//  Copyright © 2017 Jeffrey Weng. All rights reserved.
//

import Foundation
import UIKit
class NodeMapController : UIViewController{
    @IBOutlet weak var nodeCreator: UIButton!
    @IBOutlet weak var node: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
   
    @IBAction func nodeCreatorTapped(_ sender: Any) {
        let randomX = Int(arc4random_uniform(100) + 100)
        let randomY = Int(arc4random_uniform(100) + 200)
        
        let button = UIButton(frame: CGRect(x: randomX, y: randomY, width: 100, height: 50))
        button.backgroundColor = .green
        button.setTitle("Test Button", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        self.view.addSubview(button)
    }
    
    func buttonAction(sender: UIButton!) {
        print("Button tapped")
    }
    

}
