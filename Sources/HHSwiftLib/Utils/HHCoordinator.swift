//
//  HHCoordinator.swift
//  HHSwiftLib
//
//  Created by MAC on 2024/3/12.
//

import Foundation
import UIKit

public enum ShowType {
    case present(fromController: UIViewController)
    case push(navController: UINavigationController)
}

public protocol HHCoordinator {
    func start()
}

