//
//  HHDevice.swift
//  HHSwiftLib
//
//  Created by MAC on 2024/3/12.
//

import Foundation
import UIKit
/// 判断是否iphoneX 带刘海
public func IsBangs_iPhone() -> Bool {
    return BottomHomeHeight > 0
}

/// 是否是X以上
public var isX: Bool {
    return BottomHomeHeight > 0
}

///判断是否iPad
public let IsIPAD: Bool = (UIDevice.current.userInterfaceIdiom == .pad) ? true: false


// MARK:- 系统版本
public let SystemVersion: String = UIDevice.current.systemVersion

public func Later_iOS11() -> Bool {
    guard #available(iOS 11.0, *) else {
        return false
    }
    return true
}

public func Later_iOS12() -> Bool {
    guard #available(iOS 12.0, *) else {
        return false
    }
    return true
}

public func Later_iOS13() -> Bool {
    guard #available(iOS 13.0, *) else {
        return false
    }
    return true
}

public func Later_iOS14() -> Bool {
    guard #available(iOS 14.0, *) else {
        return false
    }
    return true
}

public func Later_iOS15() -> Bool {
    guard #available(iOS 15.0, *) else {
        return false
    }
    return true
}

public func Later_iOS16() -> Bool {
    guard #available(iOS 16.0, *) else {
        return false
    }
    return true
}

public func platformString() -> String {
    var systemInfo = utsname()
    uname(&systemInfo)
    let machineMirror = Mirror(reflecting: systemInfo.machine)
    let identifier = machineMirror.children.reduce("") { identifier, element in
        guard let value = element.value as? Int8, value != 0 else { return identifier }
        return identifier + String(UnicodeScalar(UInt8(value)))
    }
    
    switch identifier {
    case "iPod1,1":  return "iPod Touch 1"
    case "iPod2,1":  return "iPod Touch 2"
    case "iPod3,1":  return "iPod Touch 3"
    case "iPod4,1":  return "iPod Touch 4"
    case "iPod5,1":  return "iPod Touch 5"
    case "iPod7,1":  return "iPod Touch 6"
        
    case "iPhone3,1", "iPhone3,2", "iPhone3,3":  return "iPhone 4"
    case "iPhone4,1":  return "iPhone 4s"
    case "iPhone5,1":  return "iPhone 5"
    case "iPhone5,2":  return "iPhone 5"
    case "iPhone5,3", "iPhone5,4":  return "iPhone 5c"
    case "iPhone6,1", "iPhone6,2":  return "iPhone 5s"
    case "iPhone7,2":  return "iPhone 6"
    case "iPhone7,1":  return "iPhone 6 Plus"
    case "iPhone8,1":  return "iPhone 6s"
    case "iPhone8,2":  return "iPhone 6s Plus"
    case "iPhone8,4":  return "iPhone SE"
    case "iPhone9,1", "iPhone9,3":  return "iPhone 7"
    case "iPhone9,2", "iPhone9,4":  return "iPhone 7 Plus"
    case "iPhone10,1", "iPhone10,4": return "iPhone 8"
    case "iPhone10,2", "iPhone10,5": return "iPhone 8 Plus"
    case "iPhone10,3", "iPhone10,6": return "iPhone X"
        
    case "iPad1,1": return "iPad"
    case "iPad1,2": return "iPad 3G"
    case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":  return "iPad 2"
    case "iPad2,5", "iPad2,6", "iPad2,7":  return "iPad Mini"
    case "iPad3,1", "iPad3,2", "iPad3,3":  return "iPad 3"
    case "iPad3,4", "iPad3,5", "iPad3,6":  return "iPad 4"
    case "iPad4,1", "iPad4,2", "iPad4,3":  return "iPad Air"
    case "iPad4,4", "iPad4,5", "iPad4,6":  return "iPad Mini 2"
    case "iPad4,7", "iPad4,8", "iPad4,9":  return "iPad Mini 3"
    case "iPad5,1", "iPad5,2":  return "iPad Mini 4"
    case "iPad5,3", "iPad5,4":  return "iPad Air 2"
    case "iPad6,3", "iPad6,4":  return "iPad Pro 9.7"
    case "iPad6,7", "iPad6,8":  return "iPad Pro 12.9"
        
    case "AppleTV2,1":  return "Apple TV 2"
    case "AppleTV3,1","AppleTV3,2":  return "Apple TV 3"
    case "AppleTV5,3":  return "Apple TV 4"
        
    case "i386", "x86_64":  return "iPhone Simulator"
        
    default:  return identifier
    }
}

public enum Device {
    /// iPhone 5, 5s, 5c, SE, iPod Touch 5-6th.
    case screen4Inch
    /// iPhone 6, 6s, 7, 8, SE2
    case screen4_7Inch
    /// iPhone 12,13Mini
    case screen5_4Inch
    /// iPhone 6+, 6s+, 7+, 8+
    case screen5_5Inch
    /// iPhone X, Xs, 11Pro
    case screen5_8Inch
    /// iPhone XR, 11 , 12,13 , 12,13Pro
    case screen6_1Inch
    /// iPhone Xs Max, 11 Pro Max
    case screen6_5Inch
    /// iPhone 12,13 Pro MAX
    case screen6_7Inch
    case unknown
    
    public static var current: Device {
       return Device.size()
    }
    
    static public func size() -> Device {
        let w: Double = Double(UIScreen.main.bounds.width)
        let h: Double = Double(UIScreen.main.bounds.height)
        let screenHeight: Double = max(w, h)
        
        switch screenHeight {
            
        case 568:
            return .screen4Inch
        case 667:
            return UIScreen.main.scale == 3.0 ? .screen5_5Inch : .screen4_7Inch
        case 736:
            return .screen5_5Inch
        case 780:
            return .screen5_4Inch
        case 812:
            if #available(iOS 11.0, *) {
                return UIApplication.shared.windows.first?.safeAreaLayoutGuide.layoutFrame.minY != 44 ?  .screen5_4Inch : .screen5_8Inch
            } else {
                return .screen5_8Inch
            }
        case 844 :
            return .screen6_1Inch
        case 896:
            return  UIScreen.main.scale == 3.0 ? .screen6_5Inch : .screen6_1Inch
        case 926:
            return .screen6_7Inch
        default:
            return .unknown
        }
    }
    
    public static var isDevice4: Bool {
        if Device.size() == .screen4Inch {
            return true
        }
        return false
    }
    public static var isDevice4_7: Bool {
        if Device.size() == .screen4_7Inch {
            return true
        }
        return false
    }
    public static var isDevice5_5: Bool {
        if Device.size() == .screen5_5Inch {
            return true
        }
        return false
    }
    public static var isDevice5_4: Bool {
        if Device.size() == .screen5_4Inch {
            return true
        }
        return false
    }
    public static var isDevice5_8: Bool {
        if Device.size() == .screen5_8Inch {
            return true
        }
        return false
    }
    public static var isDevice6_1: Bool {
        if Device.size() == .screen6_1Inch {
            return true
        }
        return false
    }
    public static var isDevice6_5: Bool {
        if Device.size() == .screen6_5Inch {
            return true
        }
        return false
    }
    public static var isDevice6_7: Bool {
        if Device.size() == .screen6_7Inch {
            return true
        }
        return false
    }
}
