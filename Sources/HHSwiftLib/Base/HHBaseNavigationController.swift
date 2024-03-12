//
//  HHBaseNavigationController.swift
//  HHSwiftLib
//
//  Created by MAC on 2024/3/12.
//

import UIKit

open class HHBaseNavigationController: UINavigationController {

    open override var childForStatusBarStyle: UIViewController? {
        self.topViewController
    }
    
    open override var childForStatusBarHidden: UIViewController? {
        self.topViewController
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    open override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if children.count > 0 {
            viewController.hidesBottomBarWhenPushed = true

        }
        
        super.pushViewController(viewController, animated: animated)
    }

}
