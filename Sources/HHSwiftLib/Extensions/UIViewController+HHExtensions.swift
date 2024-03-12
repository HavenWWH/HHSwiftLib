//
//  UIViewController+HHExtensions.swift
//  HHSwiftLib
//
//  Created by MAC on 2024/3/12.
//


import UIKit

public extension UIViewController {
    func add(childController: UIViewController) {
        addChild(childController)
        view.addSubview(childController.view)
        childController.didMove(toParent: self)
    }
    
    func remove(childController: UIViewController) {
        childController.willMove(toParent: nil)
        childController.view.removeFromSuperview()
        childController.removeFromParent()
    }
}

extension UIViewController {
    
    
    public class func app_currentViewController() -> UIViewController? {
        var viewController : UIViewController?
        if let window = getWindow() {
            viewController = window.rootViewController
        }
        return UIViewController.getBestVC(viewController)
    }
    
    fileprivate class func getBestVC(_ viewController: UIViewController?) -> UIViewController? {
        if viewController?.presentedViewController != nil {
            return UIViewController.getBestVC(viewController?.presentedViewController)
        } else if viewController is UISplitViewController {
            let svc = viewController as? UISplitViewController
            if (svc?.viewControllers.count ?? 0) > 0 {
                return UIViewController.getBestVC(svc?.viewControllers.last)
            } else {
                return viewController
            }
        } else if viewController is UINavigationController {
            let nvc = viewController as? UINavigationController
            if (nvc?.viewControllers.count ?? 0) > 0 {
                return UIViewController.getBestVC(nvc?.topViewController)
            } else {
                return viewController
            }
        } else if viewController is UITabBarController {
            let svc = viewController as? UITabBarController
            if (svc?.viewControllers?.count ?? 0) > 0 {
                return UIViewController.getBestVC(svc?.selectedViewController)
            } else {
                return viewController
            }
        } else {
            return viewController
        }
    }

    
}
