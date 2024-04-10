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
        let date = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        return dateFormatter.string(from: date)
    }
}
