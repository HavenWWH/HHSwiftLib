//
//  UIAlertController+HHExtension.swift
//  HHSwiftLib
//
//  Created by MAC on 2024/3/12.
//


import UIKit

public typealias HHAlertActionHandler = () -> Void

public class HHAlertAction {
    let title: String
    let style: UIAlertAction.Style
    let action: HHAlertActionHandler

    init(_ title: String, style: UIAlertAction.Style , action: @escaping HHAlertActionHandler = {}) {
        self.title = title
        self.style = style
        self.action = action
    }
}

public class DefaultAction: HHAlertAction {
    public init(_ title: String, action: @escaping HHAlertActionHandler = {}) {
        super.init(title, style: .default, action: action)
    }
}

public class CancelAction: HHAlertAction {
    public init(_ title: String, action: @escaping HHAlertActionHandler = {}) {
        super.init(title, style: .cancel, action: action)
    }
}

public class DestructiveAction: HHAlertAction {
    public init(_ title: String, action: @escaping HHAlertActionHandler = {}) {
        super.init(title, style: .destructive, action: action)
    }
}

@resultBuilder public struct HHAlertControllerBuilder {
    public static func buildBlock(_ components: HHAlertAction...) -> [UIAlertAction] {
        components.map { action in
            UIAlertAction(title: action.title, style: action.style) { _ in
                action.action()
            }
        }
    }
}

public extension UIAlertController {
    
    convenience init(title: String = "",
                     message: String = "",
                     style: UIAlertController.Style = .alert,
                     cancelTitle: String = "取消",
                     confirmTitle: String = "确定",
                     cancelAction: (() -> Void)? = nil,
                     confirmAction: ((_ sender: UIAlertController) -> Void)?) {
        self.init(title: title, message: message, preferredStyle: style)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popoverController = self.popoverPresentationController {
                guard let topView = UIApplication.topViewController()?.view else {
                    return
                }
                popoverController.sourceView = topView
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
        }
        
        let _cancelAction =  UIAlertAction(title: cancelTitle , style: .cancel) { action in
            cancelAction?()
        }
        let _openAction = UIAlertAction(title:  confirmTitle, style: .default) { [weak self] action in
            if let self {
                confirmAction?(self)
            }
        }
        addAction(_cancelAction)
        addAction(_openAction)
    }
    
    func show() {
        UIApplication.topViewController()?.present(self, animated: true)
    }
}
