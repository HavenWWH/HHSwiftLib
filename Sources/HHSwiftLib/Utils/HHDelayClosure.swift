//
//  HHDelayClosure.swift
//  HHSwiftLib
//
//  Created by MAC on 2024/3/12.
//

import Foundation

@discardableResult
public func delay(_ time: TimeInterval, task: @escaping () -> Void) -> DispatchWorkItem {
    let workItem = DispatchWorkItem(block: task)
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time, execute: workItem)
    return workItem
}

