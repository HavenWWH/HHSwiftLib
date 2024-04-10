//
//  Date+HHExtension.swift
//  HHSwiftLib
//
//  Created by 王老鹰2 on 2024/4/10.
//

import Foundation


public extension Date {
    
    // 时间戳转固定格式字符串
    static func dateString(from timestamp: TimeInterval, formatter: String) -> String {
        var timeInterval = timestamp
        let length = String(format: "%.0f", timestamp).count
        if length > 10 {
            timeInterval = timestamp / 1000
        }
        let date = Date(timeIntervalSince1970: timeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        return dateFormatter.string(from: date)
    }
}
