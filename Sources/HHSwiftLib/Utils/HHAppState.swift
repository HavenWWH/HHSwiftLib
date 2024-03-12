//
//  HHAppState.swift
//  HHSwiftLib
//
//  Created by MAC on 2024/3/12.
//

import Foundation

public enum AppStateMode {
    case Debug
    case TestFlight
    case AppStore
}

public struct AppState {

    fileprivate static let isTestFlight = Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"

    public static var isDebug: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    public static var state: AppStateMode {
        if isDebug {
            return .Debug
        } else if isTestFlight {
            return .TestFlight
        } else {
            return .AppStore
        }
    }
}

