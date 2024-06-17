//
//  UIView+HHExtensions.swift
//  HHSwiftLib
//
//  Created by MAC on 2024/3/12.
//


import Foundation
import UIKit

public enum Direction {
    case top
    case left
    case bottom
    case right
}


public extension UIView {
    
    /// 尺寸
    var size: CGSize {
        get {
            return self.frame.size
        }
        set(newValue) {
            self.frame.size = CGSize(width: newValue.width, height: newValue.height)
        }
    }
    
    /// 宽度
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set(newValue) {
            self.frame.size.width = newValue
        }
    }
    
    /// 高度
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set(newValue) {
            self.frame.size.height = newValue
        }
    }
    
    /// 横坐标
    var x: CGFloat {
        get {
            return self.frame.minX
        }
        set(newValue) {
            self.frame = CGRect(x: newValue, y: y, width: width, height: height)
        }
    }
    
    /// 纵坐标
    var y: CGFloat {
        get {
            return self.frame.minY
        }
        set(newValue) {
            self.frame = CGRect(x: x, y: newValue, width: width, height: height)
        }
    }
    
    /// 右端横坐标
    var right: CGFloat {
        get {
            return frame.origin.x + frame.size.width
        }
        set(newValue) {
            frame.origin.x = newValue - frame.size.width
        }
    }
    
    /// 底端纵坐标
    var bottom: CGFloat {
        get {
            return frame.origin.y + frame.size.height
        }
        set(newValue) {
            frame.origin.y = newValue - frame.size.height
        }
    }
    
    /// 中心横坐标
    var centerX: CGFloat {
        get {
            return self.center.x
        }
        set(newValue) {
            center.x = newValue
        }
    }
    
    /// 中心纵坐标
    var centerY: CGFloat {
        get {
            return center.y
        }
        set(newValue) {
            center.y = newValue
        }
    }
    
    /// 原点
    var origin: CGPoint {
        get {
            return frame.origin
        }
        set(newValue) {
            frame.origin = newValue
        }
    }
    
    var top: CGFloat {
        get { frame.origin.y }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    /// 右上角坐标
    var topRight: CGPoint {
        get {
            return CGPoint(x: frame.origin.x + frame.size.width, y: frame.origin.y)
        }
        set(newValue) {
            frame.origin = CGPoint(x: newValue.x - width, y: newValue.y)
        }
    }
    
    /// 右下角坐标
    var bottomRight: CGPoint {
        get {
            return CGPoint(x: frame.origin.x + frame.size.width, y: frame.origin.y + frame.size.height)
        }
        set(newValue) {
            frame.origin = CGPoint(x: newValue.x - width, y: newValue.y - height)
        }
    }
    
    /// 左下角坐标
    var bottomLeft: CGPoint {
        get {
            return CGPoint(x: frame.origin.x, y: frame.origin.y + frame.size.height)
        }
        set(newValue) {
            frame.origin = CGPoint(x: newValue.x, y: newValue.y - height)
        }
    }
    
    /// 获取UIView对象某个方向缩进指定距离后的方形区域
    ///
    /// - Parameters:
    ///   - direction: 要缩进的方向
    ///   - distance: 缩进的距离
    /// - Returns: 得到的区域
    func cutRect(direction: Direction, distance: CGFloat) ->  CGRect {
        switch direction {
        case .top:
            return CGRect(x: 0, y: distance, width: self.width, height: self.height - distance)
        case .left:
            return CGRect(x: distance, y: 0, width: self.width - distance, height: self.height)
        case .right:
            return CGRect(x: 0, y: 0, width: self.width - distance, height: self.height)
        case .bottom:
            return CGRect(x: 0, y: 0, width: self.width, height: self.height - distance)
        }
    }
}

public enum GradientPoint{
    case left
    case top
    case right
    case bottom
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
    
    public var point: CGPoint {
        switch self {
        case .left:         return CGPoint(x: 0.0, y: 0.5)
        case .top:          return CGPoint(x: 0.5, y: 0.0)
        case .right:        return CGPoint(x: 1.0, y: 0.5)
        case .bottom:       return CGPoint(x: 0.5, y: 1.0)
        case .topLeft:      return CGPoint(x: 0.0, y: 0.0)
        case .topRight:     return CGPoint(x: 1.0, y: 0.0)
        case .bottomLeft:   return CGPoint(x: 0.0, y: 1.0)
        case .bottomRight:  return CGPoint(x: 1.0, y: 1.0)
        }
    }
}

public extension UIView{
    
    /// 添加背景色,主要是渐变色背景
    /// - Parameters:
    ///   - colors: 背景色数组,一个的话仅仅是设置背景色,多个的话会设置渐变色
    ///   - size: 视图大小,默认self.bounds,snap的需要注意layoutifneed
    ///   - startPoint: 渐变色起点
    ///   - endPoint: 渐变色终点
    func setBackColor(_ colors: [UIColor],
                      size: CGSize? = nil,
                      startPoint: CGPoint = GradientPoint.topLeft.point,
                      endPoint: CGPoint = GradientPoint.bottomLeft.point){

        guard colors.count >= 1 else {
            return
        }
        
        removeGradients()
        
        if colors.count < 2 {
            backgroundColor = colors.first
        }else{
            
            let gradient: CAGradientLayer = colors.gradient { gradient in
                gradient.startPoint = startPoint
                gradient.endPoint = endPoint
                return gradient
            }
            
            gradient.drawsAsynchronously = true
            layer.insertSublayer(gradient, at: 0)
            if let s = size{
                gradient.frame = .init(x: 0, y: 0, width: s.width, height: s.height)
            }else{
              gradient.frame = self.bounds
            }
        }
    }
    
    func addGradient(_ gradient: CAGradientLayer,
                     size: CGSize? = nil){
        
        removeGradients()
        
        gradient.drawsAsynchronously = true
        layer.insertSublayer(gradient, at: 0)
        if let s = size{
            gradient.frame = .init(x: 0, y: 0, width: s.width, height: s.height)
        }else{
            gradient.frame = self.bounds
        }
        
    }
    
    /// 移除渐变色背景
    func removeGradients() {
        if let sl = self.layer.sublayers {
            for layer in sl {
                if layer.isKind(of: CAGradientLayer.self) {
                    layer.removeFromSuperlayer()
                }
            }
        }
    }
}

public extension UIView {
    //返回该view所在VC,方便埋点查找
    func firstViewController() -> UIViewController? {
        for view in sequence(first: self.superview, next: { $0?.superview }) {
            if let responder = view?.next {
                if responder.isKind(of: UIViewController.self){
                    return responder as? UIViewController
                }
            }
        }
        return nil
    }
}

public extension UIView {
    ///初始化View闭包--方便快速
    static func inits<T: UIView>(_ builder: ((T) -> Void)? = nil) -> T {
        let view = T()
        view.translatesAutoresizingMaskIntoConstraints = false
        builder?(view)
        return view
    }
    
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius))

        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
}

// MARK: 动画
public extension UIView {
    
    func addRotateAnimation(withDuration duration: TimeInterval, repeatCount: Float) {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber(value: Double.pi * 2)
        rotationAnimation.duration = duration
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = repeatCount
        rotationAnimation.isRemovedOnCompletion = false
        self.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    func removeRotateAnimation() {
        self.layer.removeAnimation(forKey: "rotationAnimation")
    }
    
}


// 防重复点击
public class ClickGuard {
    private static var lastClickTime: TimeInterval = 0
    private static let clickInterval: TimeInterval = 1.5  // 设置点击间隔为2秒

    public static func canClick() -> Bool {
        let currentTime = Date().timeIntervalSince1970
        if currentTime - lastClickTime < clickInterval {
            return false
        } else {
            lastClickTime = currentTime
            return true
        }
    }
}
