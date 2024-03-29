//
//  HHTabBar.swift
//  HHSwiftLib
//
//  Created by MAC on 2024/3/12.
//

import UIKit
import SnapKit

public class HHTabBar: UITabBar {

    private var buttons: [HHTabBarButton] = []
    
    private var itemFrames = [CGRect]()
    private var tabBarItems = [UIView]()
    
    public var imageView = UIImageView()

    public override var selectedItem: UITabBarItem? {
        willSet {
            guard let newValue = newValue else {
                buttons.forEach { (item) in
                    item.select(false)
                }
                return
            }
            guard let index = items?.firstIndex(of: newValue),
                  index != NSNotFound else {
                return
            }
            select(itemAt: index, animated: false)
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    public var container: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private func configure() {
        
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        addSubview(container)
        let bottomOffset: CGFloat
        if #available(iOS 11.0, *) {
            bottomOffset = safeAreaInsets.bottom
        } else {
            bottomOffset = 0
        }
        container.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-bottomOffset)
        }
    }
    
    override public func safeAreaInsetsDidChange() {
        if #available(iOS 11.0, *) {
            super.safeAreaInsetsDidChange()
            container.snp.updateConstraints { (make) in
                make.bottom.equalToSuperview().offset(-safeAreaInsets.bottom)
            }
        } else { }
    }
    
    public override var items: [UITabBarItem]? {
        didSet {
            reloadViews()
        }
    }
    
    public override func setItems(_ items: [UITabBarItem]?, animated: Bool) {
        super.setItems(items, animated: animated)
        reloadViews()
    }
    
    func reloadViews() {
        subviews.forEach { (view) in
            if String(describing: type(of: view)) == "UITabBarButton" {
                view.removeFromSuperview()
            }
        }
        
        buttons.forEach { (bar) in
            bar.removeFromSuperview()
        }
        
        buttons = items?.map({ (item) -> HHTabBarButton in
            return self.button(forItem: item)
        }) ?? []
        
        var lastButton : HHTabBarButton?
        let itemWidth = (bounds.width - 20) / CGFloat(buttons.count)
        buttons.forEach { (button) in
            self.container.addSubview(button)
            button.snp.remakeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.width.equalTo(itemWidth)
                if let last = lastButton{
                    make.left.equalTo(last.snp.right)
                }else{
                    make.left.equalToSuperview()
                }
            }
            lastButton = button
        }
        
        layoutIfNeeded()
    }
    
    private func button(forItem item: UITabBarItem) -> HHTabBarButton {
        let button = HHTabBarButton(item: item)
        button.addTarget(self, action: #selector(btnPressed), for: .touchUpInside)
        if selectedItem != nil && item === selectedItem {
            button.select()
        }
        return button
    }
    
    @objc private func btnPressed(sender: HHTabBarButton) {
        guard let index = buttons.firstIndex(of: sender),
              index != NSNotFound,
              let item = items?[index] else {
            return
        }
        buttons.forEach { (button) in
            guard button != sender else {
                return
            }
            button.deselect()
        }
        sender.select()
        
        delegate?.tabBar?(self, didSelect: item)
    }
    
    func select(itemAt index: Int, animated: Bool = false) {
        guard index < buttons.count else {
            return
        }
        let selectedbutton = buttons[index]
        buttons.forEach { (button) in
            guard button != selectedbutton else {
                return
            }
            button.deselect(animated: false)
        }
        selectedbutton.select(animated: false)
    }
}
