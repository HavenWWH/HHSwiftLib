//
//  UIFont+HHExtensions.swift
//  HHSwiftLib
//
//  Created by MAC on 2024/3/12.
//


import Foundation
import UIKit

public enum FontType: String {
    case None = ""
    case Regular = "Regular"
    case Bold = "Bold"
    case DemiBold = "DemiBold"
    case Light = "Light"
    case UltraLight = "UltraLight"
    case Italic = "Italic"
    case Thin = "Thin"
    case Book = "Book"
    case Roman = "Roman"
    case Medium = "Medium"
    case MediumItalic = "MediumItalic"
    case CondensedMedium = "CondensedMedium"
    case CondensedExtraBold = "CondensedExtraBold"
    case SemiBold = "SemiBold"
    case BoldItalic = "BoldItalic"
    case Heavy = "Heavy"
}

public enum FontName: String {
    case HelveticaNeue
    case Helvetica
    case Futura
    case Menlo
    case Avenir
    case AvenirNext
    case Didot
    case AmericanTypewriter
    case Baskerville
    case Geneva
    case GillSans
    case SanFranciscoDisplay
    case Seravek
    case SFProDisplay
    case PingFangSC
}

public extension UIFont {
    
    public class func Font(_ name: FontName, type: FontType, size: CGFloat) -> UIFont! {
        
        let fontName = name.rawValue + "-" + type.rawValue
        if let font = UIFont(name: fontName, size: size) {
            return font
        }
        
        let fontNameNone = name.rawValue
        if let font = UIFont(name: fontNameNone, size: size) {
            return font
        }
        
        let fontNameReqular = name.rawValue + "-" + "Regular"
        if let font = UIFont(name: fontNameReqular, size: size) {
            return font
        }
        
        return nil
    }
    
    public class func HelveticaNeue(type: FontType, size: CGFloat) -> UIFont {
        return Font(.HelveticaNeue, type: type, size: size)
    }
    
    public class func AvenirNext(type: FontType, size: CGFloat) -> UIFont {
        return Font(.AvenirNext, type: type, size: size)
    }
    
    public class func AvenirNextDemiBold(size: CGFloat) -> UIFont {
        return Font(.AvenirNext, type: .DemiBold, size: size)
    }
    
    public class func AvenirNextRegular(size: CGFloat) -> UIFont {
        return Font(.AvenirNext, type: .Regular, size: size)
    }
    static func dinAlternate(_ size: CGFloat) -> UIFont {
        return UIFont(name: "DINAlternate-Bold", size: size) ?? .systemFont(ofSize: size)
    }
}
