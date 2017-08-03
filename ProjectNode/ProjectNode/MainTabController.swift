//
//  MainTabController.swift
//  ProjectNode
//
//  Created by Jeffrey Weng on 8/2/17.
//  Copyright © 2017 Jeffrey Weng. All rights reserved.
//

import Foundation
import UIKit
class MainTabController : UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask(rawValue: UInt(Int(UIInterfaceOrientationMask.portrait.rawValue)))
    }

}
