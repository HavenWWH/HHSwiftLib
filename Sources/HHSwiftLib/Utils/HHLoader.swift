//
//  HHLoader.swift
//  HHSwiftLib
//
//  Created by MAC on 2024/3/12.
//

import Foundation
import UIKit

extension Bundle {
    
    #if !ENABLE_SPM
    private class _BundleClass { }
    #endif
    
    static var current: Bundle {
        #if ENABLE_SPM
        return Bundle.module
        #else
        return Bundle(for: _BundleClass.self)
        #endif
    }
}

public struct L{
    
    static var bundle: Bundle = {
        let path = Bundle(for: HHBaseViewController.self).path(forResource: "HHSwiftBundle", ofType: "bundle")
        let bundle = Bundle(path: path ?? "")
        return bundle ?? Bundle.current
    }()
    
    public static func image(_ named: String) -> UIImage {
        guard let image = UIImage(named: named, in: bundle, compatibleWith: nil) else {
            let image = UIImage(named: named)
            return image ?? UIImage()
        }
        return image
    }
    
    public static func color(_ named: String) -> UIColor {
        guard let color = UIColor(named: named, in: bundle, compatibleWith: nil) else {
            return UIColor(named: named) ?? UIColor.clear
        }
        return color
    }
}
