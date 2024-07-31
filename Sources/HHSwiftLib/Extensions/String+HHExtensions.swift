//
//  String+HHExtensions.swift
//  HHSwiftLib
//
//  Created by MAC on 2024/3/12.
//


import Foundation
import UIKit
import CryptoKit
import CommonCrypto

extension String {
    
    /// Init string with a base64 encoded string
    /// base64转字符串
    init ? (base64: String) {
        let pad = String(repeating: "=", count: base64.length % 4)
        let base64Padded = base64 + pad
        if let decodedData = Data(base64Encoded: base64Padded, options: NSData.Base64DecodingOptions(rawValue: 0)), let decodedString = NSString(data: decodedData, encoding: String.Encoding.utf8.rawValue) {
            self.init(decodedString)
            return
        }
        return nil
    }
    
    /// md5加密
    public func app_md5() -> String {
        if let data = self.data(using: .utf8) {
            var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            _ = data.withUnsafeBytes { (body) in
                CC_MD5(body.baseAddress, CC_LONG(data.count), &digest)
            }

            var md5String = ""
            for byte in digest {
                md5String += String(format:"%02x", byte)
            }
            return md5String
        }
        return self
    }
    
    /// sha256加密
    public func sha256() -> String {
        if let data = self.data(using: .utf8) {
            var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
            _ = data.withUnsafeBytes { (body) in
                CC_SHA256(body.baseAddress, CC_LONG(data.count), &digest)
            }

            var sha256String = ""
            for byte in digest {
                sha256String += String(format:"%02x", byte)
            }
            return sha256String
        }
        return self
    }

    
    /// base64 encoded of string
    ///  字符串base64编码
    var base64: String {
        let plainData = (self as NSString).data(using: String.Encoding.utf8.rawValue)
        let base64String = plainData!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        return base64String
    }
    
    /// Cut string from integerIndex to the end
    ///  返回对应索引的字符串
    public subscript(integerIndex: Int) -> Character {
        let index = self.index(startIndex, offsetBy: integerIndex)
        return self[index]
    }
    
    /// Cut string from range
    ///  返回指定范围字符串
    public subscript(integerRange: Range<Int>) -> String {
        let start = self.index(startIndex, offsetBy: integerRange.lowerBound)
        let end = self.index(startIndex, offsetBy: integerRange.upperBound)
        return String(self[start..<end])
    }
    
    /// Cut string from closedrange
    /// 返回字符串中对应的范围的字符串
    public subscript(integerClosedRange: ClosedRange<Int>) -> String {
        return self[integerClosedRange.lowerBound..<(integerClosedRange.upperBound + 1)]
    }
    
    /// Character count
    /// 长度
    public var length: Int {
        return self.count
    }
    
    /// Counts number of instances of the input inside String
    /// 字符串中子字符串出现的次数
    public func count(_ substring: String) -> Int {
        return components(separatedBy: substring).count - 1
    }
    
    /// Capitalizes first character of String
    /// 字符串第一个字符大写
    public mutating func capitalizeFirst() {
        guard self.count > 0 else { return }
        self.replaceSubrange(startIndex...startIndex, with: String(self[startIndex]).capitalized)
    }
    
    /// Capitalizes first character of String, returns a new string
    /// 字符串第一个字符大写 并返回结果
    public func capitalizedFirst() -> String {
        guard self.count > 0 else { return self }
        var result = self
        
        result.replaceSubrange(startIndex...startIndex, with: String(self[startIndex]).capitalized)
        return result
    }
    
    /// Uppercases first 'count' characters of String
    /// 字符串前面多少个字符转大写
    public mutating func uppercasePrefix(_ count: Int) {
        guard self.count > 0 && count > 0 else { return }
        self.replaceSubrange(startIndex..<self.index(startIndex, offsetBy: min(count, length)),
                             with: String(self[startIndex..<self.index(startIndex, offsetBy: min(count, length))]).uppercased())
    }
    
    /// Uppercases first 'count' characters of String, returns a new string
    /// 字符串前面多少个字符转大写并返回
    public func uppercasedPrefix(_ count: Int) -> String {
        guard self.count > 0 && count > 0 else { return self }
        var result = self
        result.replaceSubrange(startIndex..<self.index(startIndex, offsetBy: min(count, length)),
                               with: String(self[startIndex..<self.index(startIndex, offsetBy: min(count, length))]).uppercased())
        return result
    }
    
    /// Uppercases last 'count' characters of String
    /// 字符串最后多少个字符转大写
    public mutating func uppercaseSuffix(_ count: Int) {
        guard self.count > 0 && count > 0 else { return }
        self.replaceSubrange(self.index(endIndex, offsetBy: -min(count, length))..<endIndex,
                             with: String(self[self.index(endIndex, offsetBy: -min(count, length))..<endIndex]).uppercased())
    }
    
    /// Uppercases last 'count' characters of String, returns a new string
    /// 字符串最后多少个字符转大写并返回
    public func uppercasedSuffix(_ count: Int) -> String {
        guard self.count > 0 && count > 0 else { return self }
        var result = self
        result.replaceSubrange(self.index(endIndex, offsetBy: -min(count, length))..<endIndex,
                               with: String(self[self.index(endIndex, offsetBy: -min(count, length))..<endIndex]).uppercased())
        return result
    }
    
    /// Uppercases string in range 'range' (from range.startIndex to range.endIndex)
    /// 字符串中指定范围字符串转大写
    public mutating func uppercase(range: CountableRange<Int>) {
        let from = max(range.lowerBound, 0), to = min(range.upperBound, length)
        guard self.count > 0 && (0..<length).contains(from) else { return }
        self.replaceSubrange(self.index(startIndex, offsetBy: from)..<self.index(startIndex, offsetBy: to),
                             with: String(self[self.index(startIndex, offsetBy: from)..<self.index(startIndex, offsetBy: to)]).uppercased())
    }
    
    /// Uppercases string in range 'range' (from range.startIndex to range.endIndex), returns new string
    /// 字符串中指定范围字符串转大写并返回
    public func uppercased(range: CountableRange<Int>) -> String {
        let from = max(range.lowerBound, 0), to = min(range.upperBound, length)
        guard self.count > 0 && (0..<length).contains(from) else { return self }
        var result = self
        result.replaceSubrange(self.index(startIndex, offsetBy: from)..<self.index(startIndex, offsetBy: to),
                               with: String(self[self.index(startIndex, offsetBy: from)..<self.index(startIndex, offsetBy: to)]).uppercased())
        return result
    }
    
    /// Lowercases first character of String
    /// 字符串第一个字符小写
    public mutating func lowercaseFirst() {
        guard self.count > 0 else { return }
        self.replaceSubrange(startIndex...startIndex, with: String(self[startIndex]).lowercased())
    }
    
    /// Lowercases first character of String, returns a new string
    /// 字符串第一个字符小写并返回
    public func lowercasedFirst() -> String {
        guard self.count > 0 else { return self }
        var result = self
        result.replaceSubrange(startIndex...startIndex, with: String(self[startIndex]).lowercased())
        return result
    }
    
    /// Lowercases first 'count' characters of String
    /// 字符串前面多个字符转小写
    public mutating func lowercasePrefix(_ count: Int) {
        guard self.count > 0 && count > 0 else { return }
        self.replaceSubrange(startIndex..<self.index(startIndex, offsetBy: min(count, length)),
                             with: String(self[startIndex..<self.index(startIndex, offsetBy: min(count, length))]).lowercased())
    }
    
    /// Lowercases first 'count' characters of String, returns a new string
    /// 字符串前面多个字符转小写并返回
    public func lowercasedPrefix(_ count: Int) -> String {
        guard self.count > 0 && count > 0 else { return self }
        var result = self
        result.replaceSubrange(startIndex..<self.index(startIndex, offsetBy: min(count, length)),
                               with: String(self[startIndex..<self.index(startIndex, offsetBy: min(count, length))]).lowercased())
        return result
    }
    
    /// Lowercases last 'count' characters of String
    /// 字符串最后多个字符转小写
    public mutating func lowercaseSuffix(_ count: Int) {
        guard self.count > 0 && count > 0 else { return }
        self.replaceSubrange(self.index(endIndex, offsetBy: -min(count, length))..<endIndex,
                             with: String(self[self.index(endIndex, offsetBy: -min(count, length))..<endIndex]).lowercased())
    }
    
    /// Lowercases last 'count' characters of String, returns a new string
    /// 字符串最后多个字符转小写并返回
    public func lowercasedSuffix(_ count: Int) -> String {
        guard self.count > 0 && count > 0 else { return self }
        var result = self
        result.replaceSubrange(self.index(endIndex, offsetBy: -min(count, length))..<endIndex,
                               with: String(self[self.index(endIndex, offsetBy: -min(count, length))..<endIndex]).lowercased())
        return result
    }
    
    /// Lowercases string in range 'range' (from range.startIndex to range.endIndex)
    /// 字符串多个字符转小写
    public mutating func lowercase(range: CountableRange<Int>) {
        let from = max(range.lowerBound, 0), to = min(range.upperBound, length)
        guard self.count > 0 && (0..<length).contains(from) else { return }
        self.replaceSubrange(self.index(startIndex, offsetBy: from)..<self.index(startIndex, offsetBy: to),
                             with: String(self[self.index(startIndex, offsetBy: from)..<self.index(startIndex, offsetBy: to)]).lowercased())
    }
    
    /// Lowercases string in range 'range' (from range.startIndex to range.endIndex), returns new string
    /// 字符串多个字符转小写并返回
    public func lowercased(range: CountableRange<Int>) -> String {
        let from = max(range.lowerBound, 0), to = min(range.upperBound, length)
        guard self.count > 0 && (0..<length).contains(from) else { return self }
        var result = self
        result.replaceSubrange(self.index(startIndex, offsetBy: from)..<self.index(startIndex, offsetBy: to),
                               with: String(self[self.index(startIndex, offsetBy: from)..<self.index(startIndex, offsetBy: to)]).lowercased())
        return result
    }
    
    /// Counts whitespace & new lines
    @available(*, deprecated, renamed: "isBlank")
    /// 字符串包含空格和换行
    public func isOnlyEmptySpacesAndNewLineCharacters() -> Bool {
        let characterSet = CharacterSet.whitespacesAndNewlines
        let newText = self.trimmingCharacters(in: characterSet)
        return newText.isEmpty
    }
    
    /// Checks if string is empty or consists only of whitespace and newline characters
    /// 判断字符串是否为空或只包含空格和换行字符，是则返回true
    public var isBlank: Bool {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty
    }
    
    /// Trims white space and new line characters
    /// 去除开头和结尾的空格和换行字符
    public mutating func trim() {
        self = self.trimmed()
    }
    
    /// Trims white space and new line characters, returns a new string
    /// 去除开头和结尾的空格和换行字符的新字符串
    public func trimmed() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// Position of begining character of substing
    /// 查找字符串中子字符串的位置
    public func positionOfSubstring(_ subString: String, caseInsensitive: Bool = false, fromEnd: Bool = false) -> Int {
        if subString.isEmpty {
            return -1
        }
        var searchOption = fromEnd ? NSString.CompareOptions.anchored : NSString.CompareOptions.backwards
        if caseInsensitive {
            searchOption.insert(NSString.CompareOptions.caseInsensitive)
        }
        if let range = self.range(of: subString, options: searchOption), !range.isEmpty {
            return self.distance(from: self.startIndex, to: range.lowerBound)
        }
        return -1
    }
    
    /// split string using a spearator string, returns an array of string
    /// 按照指定的分隔符拆分字符串
    public func split(_ separator: String) -> [String] {
        return self.components(separatedBy: separator).filter {
            !$0.trimmed().isEmpty
        }
    }
    
    /// split string with delimiters, returns an array of string
    /// 用于按照指定的字符集拆分字符串，并返回一个去除空格和空字符串后的子串数组
    public func split(_ characters: CharacterSet) -> [String] {
        return self.components(separatedBy: characters).filter {
            !$0.trimmed().isEmpty
        }
    }
    
    /// Returns count of words in string
    /// 用于获取字符串中单词的数量
    public var countofWords: Int {
        let regex = try? NSRegularExpression(pattern: "\\w+", options: NSRegularExpression.Options())
        return regex?.numberOfMatches(in: self, options: NSRegularExpression.MatchingOptions(), range: NSRange(location: 0, length: self.length)) ?? 0
    }
    
    /// Returns count of paragraphs in string
    /// 字符串中段落的数量
    public var countofParagraphs: Int {
        let regex = try? NSRegularExpression(pattern: "\\n", options: NSRegularExpression.Options())
        let str = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return (regex?.numberOfMatches(in: str, options: NSRegularExpression.MatchingOptions(), range: NSRange(location: 0, length: str.length)) ?? -1) + 1
    }
    
    /// 用于将 NSRange 转换为 Range<String.Index>
    internal func rangeFromNSRange(_ nsRange: NSRange) -> Range<String.Index>? {
        
        let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location)
        let to16 = utf16.index(from16, offsetBy: nsRange.length)
        if let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self) {
            return from ..< to
        }
        return nil
    }
    
    /// Find matches of regular expression in string
    /// 文本中查找符合给定正则表达式的匹配项，并返回匹配项的字符串数组
    public func matchesForRegexInText(_ regex: String!) -> [String] {
        let regex = try? NSRegularExpression(pattern: regex, options: [])
        let results = regex?.matches(in: self, options: [], range: NSRange(location: 0, length: self.length)) ?? []
        return results.map { String(self[self.rangeFromNSRange($0.range)!]) }
    }
    
    
    /// Checks if String contains Email
    /// 字符串是否符合电子邮件地址的格式
    public var isEmail: Bool {
        let dataDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let firstMatch = dataDetector?.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSRange(location: 0, length: length))
        return (firstMatch?.range.location != NSNotFound && firstMatch?.url?.scheme == "mailto")
    }
    
    /// Returns if String is a number
    /// 是否是数字
    public func isNumber() -> Bool {
        return NumberFormatter().number(from: self) != nil ? true : false
    }
    
    /// Extracts URLS from String
    /// 字符串中提取所有的 URL，并返回一个 URL 数组
    public var extractURLs: [URL] {
        var urls: [URL] = []
        let detector: NSDataDetector?
        do {
            detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        } catch _ as NSError {
            detector = nil
        }
        
        let text = self
        
        if let detector = detector {
            detector.enumerateMatches(in: text,
                                      options: [],
                                      range: NSRange(location: 0, length: text.count),
                                      using: { (result: NSTextCheckingResult?, _, _) -> Void in
                if let result = result, let url = result.url {
                    urls.append(url)
                }
            })
        }
        
        return urls
    }
    
    /// Checking if String contains input with comparing options
    /// 字符串是否包含指定的子串
    public func contains(_ find: String, compareOption: NSString.CompareOptions) -> Bool {
        return self.range(of: find, options: compareOption) != nil
    }
    
    /// Converts String to Int
    public func toInt() -> Int? {
        if let num = NumberFormatter().number(from: self) {
            return num.intValue
        } else {
            return nil
        }
    }
    
    /// Converts String to Double
    public func toDouble() -> Double? {
        if let num = NumberFormatter().number(from: self) {
            return num.doubleValue
        } else {
            return nil
        }
    }
    
    /// Converts String to Float
    public func toFloat() -> Float? {
        if let num = NumberFormatter().number(from: self) {
            return num.floatValue
        } else {
            return nil
        }
    }
    
    /// Converts String to Bool
    public func toBool() -> Bool? {
        let trimmedString = trimmed().lowercased()
        if trimmedString == "true" || trimmedString == "false" {
            return (trimmedString as NSString).boolValue
        }
        return nil
    }
    
    /// Returns the first index of the occurency of the character in String
    /// 用于获取指定字符在字符串中的索引位置
    public func getIndexOf(_ char: Character) -> Int? {
        for (index, c) in self.enumerated() where c == char {
            return index
        }
        return nil
    }
    
    /// Converts String to NSString
    /// 转NSString
    public var toNSString: NSString { return self as NSString }
    
    #if os(iOS)
    
    /// Returns bold NSAttributedString
    /// 将字符串转换为带有粗体属性的 NSAttributedString
    public func bold() -> NSAttributedString {
        let boldString = NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)])
        return boldString
    }
    
    #endif
    
    #if os(iOS)

    /// Returns underlined NSAttributedString
    /// 将字符串转换为带下划线属性的 NSAttributedString
    public func underline() -> NSAttributedString {
        let underlineString = NSAttributedString(string: self, attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
        return underlineString
    }
    
    #endif
    
    #if os(iOS)
    
    ///  Returns italic NSAttributedString
    ///  将字符串转换为带有斜体属性的 NSAttributedString
    public func italic() -> NSAttributedString {
        let italicString = NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)])
        return italicString
    }
    
    #endif
    
    #if os(iOS)
    
    /// Returns hight of rendered string
    /// 字符串在给定宽度下的高度
    public func height(_ width: CGFloat, font: UIFont, lineBreakMode: NSLineBreakMode?) -> CGFloat {
        var attrib: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font]
        if lineBreakMode != nil {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = lineBreakMode!
            attrib.updateValue(paragraphStyle, forKey: NSAttributedString.Key.paragraphStyle)
        }
        let size = CGSize(width: width, height: CGFloat(Double.greatestFiniteMagnitude))
        return ceil((self as NSString).boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attrib, context: nil).height)
    }
    
    /// Returns hight of rendered string
    /// 字符串在给定高度下的宽度
    public func width(_ height: CGFloat, font: UIFont, lineBreakMode: NSLineBreakMode?, lineSpace: CGFloat?) -> CGFloat {
        var attrib: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font]
        if lineBreakMode != nil || lineSpace != nil {
            let paragraphStyle = NSMutableParagraphStyle()
            if let lineBreakMode = lineBreakMode {
                paragraphStyle.lineBreakMode = lineBreakMode
            }
            if let lineSpace = lineSpace {
                paragraphStyle.lineSpacing = lineSpace
            }
            attrib.updateValue(paragraphStyle, forKey: NSAttributedString.Key.paragraphStyle)
        }
        let size = CGSize(width:  CGFloat(Double.greatestFiniteMagnitude), height:height)
        return ceil((self as NSString).boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attrib, context: nil).width)
    }
    
    #endif
    
    #if os(iOS) || os(tvOS)
    
    /// Returns NSAttributedString
    /// 带颜色的NSAttributedString
    public func color(_ color: UIColor) -> NSAttributedString {
        let colorString = NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.foregroundColor: color])
        return colorString
    }
    
    /// Returns NSAttributedString
    /// 带颜色的NSAttributedString
    public func colorSubString(_ subString: String, color: UIColor) -> NSMutableAttributedString {
        var start = 0
        var ranges: [NSRange] = []
        while true {
            let range = (self as NSString).range(of: subString, options: NSString.CompareOptions.literal, range: NSRange(location: start, length: (self as NSString).length - start))
            if range.location == NSNotFound {
                break
            } else {
                ranges.append(range)
                start = range.location + range.length
            }
        }
        let attrText = NSMutableAttributedString(string: self)
        for range in ranges {
            attrText.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        }
        return attrText
    }
    
    #endif
    
    /// Checks if String contains Emoji
    /// 包含表情
    public func includesEmoji() -> Bool {
        for i in 0...length {
            let c: unichar = (self as NSString).character(at: i)
            if (0xD800 <= c && c <= 0xDBFF) || (0xDC00 <= c && c <= 0xDFFF) {
                return true
            }
        }
        return false
    }
    
    #if os(iOS)
    
    /// copy string to pasteboard
    ///  复制到粘贴板
    public func addToPasteboard() {
        let pasteboard = UIPasteboard.general
        pasteboard.string = self
    }
    
    #endif
    
    /// URL encode a string (percent encoding special chars)
    /// 对字符串进行 URL 编码
    public func urlEncoded() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    // URL encode a string (percent encoding special chars) mutating version
    /// 将调用者的值进行 URL 编码，并将结果赋值回调用者
    mutating func urlEncode() {
        self = urlEncoded()
    }
    
    // Removes percent encoding from string
    /// URL解码
    public func urlDecoded() -> String {
        return removingPercentEncoding ?? self
    }
    
    // Mutating versin of urlDecoded
    /// URL解码并返回
    mutating func urlDecode() {
        self = urlDecoded()
    }
}

extension String {
    /// 创建包含特定精度的浮点数值的字符串
    init(_ value: Float, precision: Int) {
        let nFormatter = NumberFormatter()
        nFormatter.numberStyle = .decimal
        nFormatter.maximumFractionDigits = precision
        self = nFormatter.string(from: NSNumber(value: value))!
    }
    /// 创建包含特定精度的浮点数值的字符串
    init(_ value: Double, precision: Int) {
        let nFormatter = NumberFormatter()
        nFormatter.numberStyle = .decimal
        nFormatter.maximumFractionDigits = precision
        self = nFormatter.string(from: NSNumber(value: value))!
    }
}

///  Pattern matching of strings via defined functions
///  通过函数作为模式来进行自定义匹配
public func ~=<T> (pattern: ((T) -> Bool), value: T) -> Bool {
    return pattern(value)
}

///  Can be used in switch-case
///  使用类似模式匹配的语法来检查字符串是否以特定后缀开头
public func hasPrefix(_ prefix: String) -> (_ value: String) -> Bool {
    return { (value: String) -> Bool in
        value.hasPrefix(prefix)
    }
}

/// Can be used in switch-case
/// 使用类似模式匹配的语法来检查字符串是否以特定后缀结尾
public func hasSuffix(_ suffix: String) -> (_ value: String) -> Bool {
    return { (value: String) -> Bool in
        value.hasSuffix(suffix)
    }
}

public extension String {

    /// 本地化
    func app_localizable() -> Self {
        return NSLocalizedString(self, comment: "")
    }
}


public extension String {
    
    func toJsonArray() -> [String]?   {
        
        if let jsonData = self.data(using: .utf8) {
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String] {
                    return jsonArray
                }
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
        return nil
    }
}


public extension String {
    
    // 秒转 hms
    static func formatTime(seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let remainingSeconds = seconds % 60
        
        if hours > 0 {
            return String(format: "%02dh%02dm", hours, minutes)
        } else if minutes > 0 {
            return String(format: "%02dm%02ds", minutes, remainingSeconds)
        } else {
            return String(format: "%02ds", remainingSeconds)
        }
    }
}


public extension String {
    func baseURLWithPath() -> String {
        guard let url = URL(string: self) else {
            return self
        }
        if let host = url.host {
            return url.scheme.flatMap { "\($0)://\(host)\(url.path)" } ?? self
        }
        return url.absoluteString
    }
}
