//
//  HHCustomNavigationBar.swift
//  HHSwiftLib
//
//  Created by MAC on 2024/3/12.
//

import UIKit

fileprivate let HHDefaultTitleSize:CGFloat = 18
fileprivate let HHDefaultTitleColor = UIColor.black
fileprivate let HHDefaultBackgroundColor = UIColor.white

// MARK: - Router
extension UIViewController {
    
    func hh_toLastViewController(animated: Bool) {
        if self.navigationController != nil {
            if self.navigationController?.viewControllers.count == 1 {
                self.dismiss(animated: animated, completion: nil)
            } else {
                self.navigationController?.popViewController(animated: animated)
            }
        } else if self.presentingViewController != nil {
            self.dismiss(animated: animated, completion: nil)
        }
    }

    class func app_currentViewController(from fromVC: UIViewController) -> UIViewController {
        if fromVC.isKind(of: UINavigationController.self) {
            let navigationController = fromVC as! UINavigationController
            return app_currentViewController(from: navigationController.viewControllers.last!)
        }
        else if fromVC.isKind(of: UITabBarController.self) {
            let tabBarController = fromVC as! UITabBarController
            return app_currentViewController(from: tabBarController.selectedViewController!)
        }
        else if fromVC.presentedViewController != nil {
            return app_currentViewController(from:fromVC.presentingViewController!)
        }
        else {
            return fromVC
        }
    }
}

public class HHCustomNavigationBar: UIView {

    public var onClickLeftButton:(()->())?
    public var onClickRightButton:(()->())?
    public var title:String? {
        willSet {
            titleLabel.isHidden = false
            titleLabel.text = newValue
        }
    }
    
    public var titleLabelColor:UIColor? {
        willSet {
            titleLabel.textColor = newValue
        }
    }
    
    public var titleLabelFont:UIFont? {
        willSet {
            titleLabel.font = newValue
        }
    }
    
    public var barBackgroundColor:UIColor? {
        willSet {
            backgroundImageView.isHidden = true
            backgroundView.isHidden = false
            backgroundView.backgroundColor = newValue
        }
    }
    
    public var barBackgroundImage:UIImage? {
        willSet {
            backgroundView.isHidden = true
            backgroundImageView.isHidden = false
            backgroundImageView.image = newValue
        }
    }
    
    // fileprivate UI variable
    fileprivate lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.textColor = HHDefaultTitleColor
        label.font = UIFont.systemFont(ofSize: HHDefaultTitleSize)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    fileprivate lazy var leftButton:UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .center
        button.isHidden = true
        button.addTarget(self, action: #selector(clickBack), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var rightButton:UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .center
        button.isHidden = true
        button.addTarget(self, action: #selector(clickRight), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var bottomLine:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: (218.0/255.0), green: (218.0/255.0), blue: (218.0/255.0), alpha: 1.0)
        return view
    }()
    
    fileprivate lazy var backgroundView:UIView = {
        let view = UIView()
        return view
    }()
    
    fileprivate lazy var backgroundImageView:UIImageView = {
        let imgView = UIImageView()
        imgView.isHidden = true
        return imgView
    }()
    
    // init
    public class func CustomNavigationBar() -> HHCustomNavigationBar {
        let frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: CGFloat(NavAndStatusHeight))
        return HHCustomNavigationBar(frame: frame)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        addSubview(backgroundView)
        addSubview(backgroundImageView)
        addSubview(leftButton)
        addSubview(titleLabel)
        addSubview(rightButton)
        addSubview(bottomLine)
        updateFrame()
        backgroundColor = UIColor.clear
        backgroundView.backgroundColor = HHDefaultBackgroundColor
    }
    
    func updateFrame() {
        let top:CGFloat = StatusBarHeight()
        let margin:CGFloat = 0
        let buttonHeight:CGFloat = 44
        let buttonWidth:CGFloat = 44
        let titleLabelHeight:CGFloat = 44
        let titleLabelWidth:CGFloat = 230
        
        backgroundView.frame = self.bounds
        backgroundImageView.frame = self.bounds
        leftButton.frame = CGRect(x: margin, y: top, width: buttonWidth, height: buttonHeight)
        rightButton.frame = CGRect(x: ScreenWidth-buttonWidth-margin-10, y: top, width: buttonWidth, height: buttonHeight)
        titleLabel.frame = CGRect(x: (ScreenWidth-titleLabelWidth)/2.0, y: top, width: titleLabelWidth, height: titleLabelHeight)
        bottomLine.frame = CGRect(x: 0, y: bounds.height-0.5, width: ScreenWidth, height: 0.5)
    }

}

extension HHCustomNavigationBar {
    public func hh_setBottomLineHidden(hidden:Bool) {
        bottomLine.isHidden = hidden
    }
    public func hh_setBackgroundAlpha(alpha:CGFloat) {
        backgroundView.alpha = alpha
        backgroundImageView.alpha = alpha
        bottomLine.alpha = alpha
    }
    public func hh_setTintColor(color:UIColor) {
        leftButton.setTitleColor(color, for: .normal)
        rightButton.setTitleColor(color, for: .normal)
        titleLabel.textColor = color
    }
    
    // 左右按钮共有方法
    public func hh_setLeftButton(normal:UIImage, highlighted:UIImage) {
        hh_setLeftButton(normal: normal, highlighted: highlighted, title: nil, titleColor: nil)
    }
    public func hh_setLeftButton(image:UIImage) {
        hh_setLeftButton(normal: image, highlighted: image, title: nil, titleColor: nil)
    }
    public func hh_setLeftButton(title:String, titleColor:UIColor) {
        hh_setLeftButton(normal: nil, highlighted: nil, title: title, titleColor: titleColor)
    }
    
    public func hh_setRightButton(normal:UIImage, highlighted:UIImage) {
        hh_setRightButton(normal: normal, highlighted: highlighted, title: nil, titleColor: nil)
    }
    public func hh_setRightButton(image:UIImage) {
        hh_setRightButton(normal: image, highlighted: image, title: nil, titleColor: nil)
    }
    public func hh_setRightButton(title:String, titleColor:UIColor) {
        hh_setRightButton(normal: nil, highlighted: nil, title: title, titleColor: titleColor)
    }
    
    
    // 左右按钮私有方法
    private func hh_setLeftButton(normal:UIImage?, highlighted:UIImage?, title:String?, titleColor:UIColor?) {
        leftButton.isHidden = false
        leftButton.setImage(normal, for: .normal)
        leftButton.setImage(highlighted, for: .highlighted)
        leftButton.setTitle(title, for: .normal)
        leftButton.setTitleColor(titleColor, for: .normal)
    }
    
    private func hh_setRightButton(normal:UIImage?, highlighted:UIImage?, title:String?, titleColor:UIColor?) {
        rightButton.isHidden = false
        rightButton.setImage(normal, for: .normal)
        rightButton.setImage(highlighted, for: .highlighted)
        rightButton.setTitle(title, for: .normal)
        rightButton.setTitleColor(titleColor, for: .normal)
    }
}


// MARK: - 导航栏左右按钮事件
extension HHCustomNavigationBar {
    @objc func clickBack() {
        if let onClickBack = onClickLeftButton {
            onClickBack()
        } else {
            let currentVC = UIViewController.app_currentViewController()
            currentVC?.hh_toLastViewController(animated: true)
        }
    }
    
    @objc func clickRight() {
        if let onClickRight = onClickRightButton {
            onClickRight()
        }
    }
}
