//
//  UIColor+HHExtensions.swift
//  HHSwiftLib
//
//  Created by MAC on 2024/3/12.
//

import Foundation
import UIKit

extension UIColor {
    
    public convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
    
    public convenience init?(hexString: String, alpha: CGFloat = 1.0) {
        var formatted = hexString.replacingOccurrences(of: "0x", with: "")
        formatted = formatted.replacingOccurrences(of: "#", with: "")
        if let hex = Int(formatted, radix: 16) {
            let red = CGFloat(CGFloat((hex & 0xFF0000) >> 16)/255.0)
            let green = CGFloat(CGFloat((hex & 0x00FF00) >> 8)/255.0)
            let blue = CGFloat(CGFloat((hex & 0x0000FF) >> 0)/255.0)
            self.init(red: red, green: green, blue: blue, alpha: alpha)
        } else {
            return nil
        }
    }
    
    public convenience init(gray: CGFloat, alpha: CGFloat = 1) {
        self.init(red: gray/255, green: gray/255, blue: gray/255, alpha: alpha)
    }
    
    ///简化RGB颜色写法
    public class func RGBA(r: Int, g: Int, b: Int, a: CGFloat) -> UIColor {
        let redFloat = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0
        return UIColor(red: redFloat, green: green, blue: blue, alpha: a)
    }
    
    public var redComponent: Int {
        var r: CGFloat = 0
        getRed(&r, green: nil, blue: nil, alpha: nil)
        return Int(r * 255)
    }
    
    public var greenComponent: Int {
        var g: CGFloat = 0
        getRed(nil, green: &g, blue: nil, alpha: nil)
        return Int(g * 255)
    }
    
    public var blueComponent: Int {
        var b: CGFloat = 0
        getRed(nil, green: nil, blue: &b, alpha: nil)
        return Int(b * 255)
    }
    
    public var alpha: CGFloat {
        var a: CGFloat = 0
        getRed(nil, green: nil, blue: nil, alpha: &a)
        return a
    }
    
    public func toInt() -> Int {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        let colorInt = (Int(a * 255) << 24) | (Int(r * 255) << 16) | (Int(g * 255) << 8) | Int(b * 255)
        return colorInt
    }
    
    ///最小饱和度值
    func color(_ minSaturation: CGFloat) -> UIColor {
      var (hue, saturation, brightness, alpha): (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 0.0)
      getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
      
      return saturation < minSaturation
        ? UIColor(hue: hue, saturation: minSaturation, brightness: brightness, alpha: alpha)
       : self
    }
    
    /// 渐变色
    public class func app_gradientColor(size: CGSize, colors: [UIColor], direction: gradientColorDirection = .left2Right) -> UIColor? {
        if let image = UIImage.app_gradientColor(size: size, colors: colors, direction: direction) {
            return UIColor(patternImage: image)
        }
        return UIColor.black
    }
    
    ///随机色
    public static var random: UIColor {
        let red = CGFloat.random(in: 0...255)
        let green = CGFloat.random(in: 0...255)
        let blue = CGFloat.random(in: 0...255)
        return UIColor(r: red, g: green, b: blue)
    }
    
    public func app_setAlpha(_ alpha: CGFloat) -> UIColor {
        return self.withAlphaComponent(alpha)
    }
}

public extension Array where Element: UIColor {
  ///通过颜色数组生成渐变色
  func gradient(_ transform: ((_ gradient: inout CAGradientLayer) -> CAGradientLayer)? = nil) -> CAGradientLayer {
    var gradient = CAGradientLayer()
    gradient.colors = self.map { $0.cgColor }
    
    if let transform = transform {
      gradient = transform(&gradient)
    }
    
    return gradient
  }
}


public extension UIColor {
    convenience init?(_ hexString: String, alpha: CGFloat = 1.0) {
        var formatted = hexString.replacingOccurrences(of: "0x", with: "")
        formatted = formatted.replacingOccurrences(of: "#", with: "")
        if let hex = Int(formatted, radix: 16) {
            let red = CGFloat(CGFloat((hex & 0xFF0000) >> 16)/255.0)
            let green = CGFloat(CGFloat((hex & 0x00FF00) >> 8)/255.0)
            let blue = CGFloat(CGFloat((hex & 0x0000FF) >> 0)/255.0)
            self.init(red: red, green: green, blue: blue, alpha: alpha)
        } else {
            return nil
        }
    }
  internal func rgbComponents() -> [CGFloat] {
    var (r, g, b, a): (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 0.0)
    getRed(&r, green: &g, blue: &b, alpha: &a)
    
    return [r, g, b]
  }
  
  var isDark: Bool {
    let RGB = rgbComponents()
    return (0.2126 * RGB[0] + 0.7152 * RGB[1] + 0.0722 * RGB[2]) < 0.5
  }
  
  var isBlackOrWhite: Bool {
    let RGB = rgbComponents()
    return (RGB[0] > 0.91 && RGB[1] > 0.91 && RGB[2] > 0.91) || (RGB[0] < 0.09 && RGB[1] < 0.09 && RGB[2] < 0.09)
  }
  
  var isBlack: Bool {
    let RGB = rgbComponents()
    return (RGB[0] < 0.09 && RGB[1] < 0.09 && RGB[2] < 0.09)
  }
  
  var isWhite: Bool {
    let RGB = rgbComponents()
    return (RGB[0] > 0.91 && RGB[1] > 0.91 && RGB[2] > 0.91)
  }
  
  func isDistinct(from color: UIColor) -> Bool {
    let bg = rgbComponents()
    let fg = color.rgbComponents()
    let threshold: CGFloat = 0.25
    var result = false
    
    if abs(bg[0] - fg[0]) > threshold || abs(bg[1] - fg[1]) > threshold || abs(bg[2] - fg[2]) > threshold {
        if abs(bg[0] - bg[1]) < 0.03 && abs(bg[0] - bg[2]) < 0.03 {
            if abs(fg[0] - fg[1]) < 0.03 && abs(fg[0] - fg[2]) < 0.03 {
          result = false
        }
      }
      result = true
    }
    
    return result
  }
  
  func isContrasting(with color: UIColor) -> Bool {
    let bg = rgbComponents()
    let fg = color.rgbComponents()
    
    let bgLum = 0.2126 * bg[0] + 0.7152 * bg[1] + 0.0722 * bg[2]
    let fgLum = 0.2126 * fg[0] + 0.7152 * fg[1] + 0.0722 * fg[2]
    let contrast = bgLum > fgLum
      ? (bgLum + 0.05) / (fgLum + 0.05)
     : (fgLum + 0.05) / (bgLum + 0.05)
    
    return 1.6 < contrast
  }
  
}
