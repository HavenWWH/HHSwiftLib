//
//  UserDefault+HHExtensions.swift
//  HHSwiftLib
//
//  Created by MAC on 2024/3/12.
//


import Foundation

public extension UserDefaults {

    /// 对象转JSON存储到UserDefaults中
    func setT<T: Codable>(object: T, forKey: String) throws {
        
        let jsonData = try JSONEncoder().encode(object)
        set(jsonData, forKey: forKey)
    }
    
    /// 解码为指定的泛型类型（必
    func getT<T: Codable>(objectType: T.Type, forKey: String) throws -> T? {
        
        guard let result = value(forKey: forKey) as? Data else {
            return nil
        }
        
        return try JSONDecoder().decode(objectType, from: result)
    }
    
    ///下标脚本
    subscript(key: String) -> Any? {
        get {
            return object(forKey: key)
        }
        set {
            set(newValue, forKey: key)
        }
    }
    
    func float(forKey key: String) -> Float? {
        return object(forKey: key) as? Float
    }
    
    func date(forKey key: String) -> Date? {
        return object(forKey: key) as? Date
    }
    
    func object<T: Codable>(_ type: T.Type, with key: String, usingDecoder decoder: JSONDecoder = JSONDecoder()) -> T? {
        guard let data = value(forKey: key) as? Data else { return nil }
        return try? decoder.decode(type.self, from: data)
    }
    
    func set<T: Codable>(object: T, forKey key: String, usingEncoder encoder: JSONEncoder = JSONEncoder()) {
        let data = try? encoder.encode(object)
        set(data, forKey: key)
    }
}

