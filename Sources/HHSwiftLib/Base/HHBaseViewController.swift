//
//  HHBaseViewController.swift
//  HHSwiftLib
//
//  Created by MAC on 2024/3/12.
//

import UIKit

open class HHBaseViewController: UIViewController {

    public lazy var navBar = HHCustomNavigationBar.CustomNavigationBar()

    
     open override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        super.viewDidLoad()
        
         self.navigationController?.navigationBar.isHidden = true
         self.setupNavBar()
         navBar.hh_setBottomLineHidden(hidden: true)
    }
    
    fileprivate func setupNavBar() {
        
        view.addSubview(navBar)

        // 设置自定义导航栏背景颜色
        navBar.backgroundColor = .white
        
        // 设置自定义导航栏标题颜色
        navBar.titleLabelColor = UIColor(hexString: "#333333")
        navBar.titleLabelFont = UIFont.Font(.PingFangSC, type: .Medium, size: 18)
        
        if self.navigationController?.children.count != 1 {
            let image = L.image("nav_icon_back")
            navBar.hh_setLeftButton(image: image)
        } else if let _ = self.presentingViewController {
            let image = L.image("nav_icon_back")
            navBar.hh_setLeftButton(image: image)
        }
    }
    
    open var statusBarHidden: Bool = false {
        didSet {
            if statusBarHidden != oldValue {
                setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
    
    open override var prefersStatusBarHidden: Bool {
        statusBarHidden
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        UIStatusBarStyle.default
    }
    
    // MARK: - Navigation 关闭手势返回
    public func closePopGestureRecognizer() {
        let target = navigationController?.interactivePopGestureRecognizer?.delegate
        let pan = UIPanGestureRecognizer(target: target, action: nil)
        view.addGestureRecognizer(pan)
    }
}
