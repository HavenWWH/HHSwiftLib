//
//  UIImage+HHExtensions.swift
//  HHSwiftLib
//
//  Created by MAC on 2024/3/12.
//


import UIKit
import CommonCrypto

extension Data {
    
    public var sha256: String {
        let hash = withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
            var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            CC_SHA256(bytes.baseAddress, CC_LONG(count), &hash)
            return hash
        }
        return hash.reduce("") { $0 + String(format:"%02x", $1) }
    }
}

extension UIImage {
    
    // 从左到右的渐变色图片
    public class func getGradientImage(size:CGSize, colors: [CGColor]) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else{return UIImage()}
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        ///设置渐变颜色
        let gradientRef = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: [0.0, 0.5, 1.0])!
        let startPoint = CGPoint(x: 0, y: size.height / 2) // 从左侧开始
        let endPoint = CGPoint(x: size.width, y: size.height / 2) // 到右侧结束
        context.drawLinearGradient(gradientRef, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(arrayLiteral: .drawsBeforeStartLocation,.drawsAfterEndLocation))
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return gradientImage ?? UIImage()
    }
    // 从左到右的渐变色图片
    public class func getGradientImage(size: CGSize, colors: [CGColor], locations: [CGFloat]? = nil) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return UIImage()
        }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        // 如果没有指定位置，则创建默认的位置
        var gradientLocations: [CGFloat]
        if let locations = locations, locations.count == colors.count {
            gradientLocations = locations
        } else {
            gradientLocations = stride(from: 0.0, through: 1.0, by: 1.0 / Double(colors.count - 1)).map { CGFloat($0) }
        }
        
        guard let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: gradientLocations) else {
            return UIImage()
        }
        
        let startPoint = CGPoint(x: 0, y: size.height / 2)
        let endPoint = CGPoint(x: size.width, y: size.height / 2)
        
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
        
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        return gradientImage ?? UIImage()
    }

    
    // view生成图片
    public class func convertToImageWith(view: UIView) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, 0.0)
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        // Draw rounded rect
        let path = UIBezierPath(roundedRect: view.bounds, cornerRadius: view.layer.cornerRadius)
        context.addPath(path.cgPath)
        context.clip()
        
        view.layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    // 判断图片类型
    public func detectImageFileType() -> String? {
        guard let data = self.pngData() else {return nil}
        let firstBytes = [UInt8](data.prefix(4))
        if firstBytes.count >= 3 {
            if firstBytes[0] == 0xFF && firstBytes[1] == 0xD8 && firstBytes[2] == 0xFF {
                return "jpg"
            } else if firstBytes[0] == 0x89 && firstBytes[1] == 0x50 && firstBytes[2] == 0x4E {
                return "png"
            } else if firstBytes[0] == 0x47 && firstBytes[1] == 0x49 && firstBytes[2] == 0x46 {
                return "gif"
            }
        }
        return nil
    }
    
    // 按最大尺寸等比例裁剪
    public func resizeImageIfNeeded(maxSize: CGFloat) -> UIImage {
        var newImage: UIImage
        
        if self.size.width > maxSize || self.size.height > maxSize {
            let scaleFactor = min(maxSize / self.size.width, maxSize / self.size.height)
            let newWidth = self.size.width * scaleFactor
            let newHeight = self.size.height * scaleFactor
            
            UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
            self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
            newImage = UIGraphicsGetImageFromCurrentImageContext() ?? self
            UIGraphicsEndImageContext()
        } else {
            newImage = self
        }
        return newImage
    }
    
    /// 生成占位图
    /// - Parameters:
    ///   - image: 小图
    ///   - imageView: 图片视图
    /// - Returns: 图片
    public static func createPlaceHolderImage(image: UIImage?, imageView: UIImageView) -> UIImage?{
        imageView.layoutIfNeeded()
        guard let image = image else {
            return nil
        }
        let name = image.sha256
        let imageName = "placeHolder_\(imageView.bounds.size.width)_\(imageView.bounds.size.height)_\(name).png"
        let fileManager = FileManager.default
        let path: String = NSHomeDirectory() + "/Documents/PlaceHolder/"
        let filePath = path + imageName
        if fileManager.fileExists(atPath: filePath) {
            guard let data = try? Data(contentsOf: URL(fileURLWithPath: filePath))
            else { return nil }
            let image = UIImage(data: data)
            return image
        }
        
        UIGraphicsBeginImageContext(imageView.bounds.size)
        if let ctx = UIGraphicsGetCurrentContext() {
            ctx.setFillColor(UIColor.clear.cgColor)
            ctx.fill(CGRect(origin: CGPoint.zero, size: imageView.bounds.size))
            
            let placeholderRect = CGRect(x: (imageView.bounds.size.width - image.size.width) / 2.0,
                                         y: (imageView.bounds.size.height - image.size.height) / 2.0,
                                         width: image.size.width,
                                         height: image.size.height)
            
            ctx.saveGState()
            ctx.translateBy(x: placeholderRect.origin.x, y: placeholderRect.origin.y)
            ctx.translateBy(x: 0, y: placeholderRect.size.height)
            ctx.scaleBy(x: 1.0, y: -1.0)
            ctx.translateBy(x: -placeholderRect.origin.x, y: -placeholderRect.origin.y)
            ctx.draw(image.cgImage!, in: placeholderRect, byTiling: false)
            ctx.restoreGState()
        }
        
        if let placeHolder = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            try? fileManager.createDirectory(at: URL(fileURLWithPath: path), withIntermediateDirectories: true, attributes: nil)
            fileManager.createFile(atPath: filePath, contents: placeHolder.pngData(), attributes: nil)
            return placeHolder
        }
        UIGraphicsEndImageContext()
        return nil
    }
    
    public var sha256: String {
        let data = Data(self.pngData()!)
        let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
            var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            CC_SHA256(bytes.baseAddress, CC_LONG(data.count), &hash)
            return hash
        }
        return hash.reduce("") { $0 + String(format:"%02x", $1) }
    }
    
    /// 是否黑白图像
    public func checkImageIsBW() -> Bool {
        
        guard let imageRef = self.cgImage, let cgImageRef = imageRef.dataProvider,
              let cfData = cgImageRef.data else {
            return false
        }
        
        let data = cfData as Data
        let pixels = [UInt8](data)
        
        let threshold: Int = 5 // 定义一个灰度阈值
        var isBW = true
        
        for i in stride(from: 0, to: data.count, by: 4) {
            let red = pixels[i]
            let green = pixels[i + 1]
            let blue = pixels[i + 2]
            
            // 检查单个通道是否远离平均值。灰色像素的 RGB 值非常接近。
            let average = (Int(red) + Int(green) + Int(blue)) / 3
            if abs(average - Int(red)) >= threshold ||
                abs(average - Int(green)) >= threshold ||
                abs(average - Int(blue)) >= threshold {
                // 可能是彩色像素
                isBW = false
                break
            }
        }
        
        // TODO: 是否需要释放
        
//        CFRelease(cfData)
        return isBW
    }
    
    /// 缩放图片 图像的宽度和高度都大于等于目标尺寸，才进行缩放
    public func app_internalScaled(newSize: CGSize) -> UIImage? {
        let width = self.size.width
        let height = self.size.height
        let newSizeWidth = newSize.width
        let newSizeHeight = newSize.height
        
        // 如果图像的宽度和高度都小于等于目标尺寸，则直接返回原始图像
        if width <= newSizeWidth && height <= newSizeHeight {
            return self
        }
        
        // 如果图像的宽度、高度或目标尺寸的宽度、高度为0，则直接返回原始图像
        if width == 0 || height == 0 || newSizeWidth == 0 || newSizeHeight == 0 {
            return self
        }
        
        var size: CGSize
        // 根据图像的宽高比和目标尺寸的宽高比，计算缩放后的大小
        if width / height > newSizeWidth / newSizeHeight {
            size = CGSize(width: newSizeWidth, height: newSizeWidth * height / width)
        } else {
            size = CGSize(width: newSizeHeight * width / height, height: newSizeHeight)
        }
        // 调用 app_drawImage 方法进行缩放，并返回缩放后的图像
        return app_drawImage(size: size)
    }

    
    // 缩放图片 只要宽和高任意一个比目标尺寸小就进行缩放
    public func app_externalScaled(newSize: CGSize) -> UIImage? {
        let width = self.size.width
        let height = self.size.height
        let newSizeWidth = newSize.width
        let newSizeHeight = newSize.height
        // 如果图像的宽度或高度小于目标尺寸，则直接返回原始图像
        if width < newSizeWidth || height < newSizeHeight {
            return self
        }
        // 如果图像的宽度或高度为0，则直接返回原始图像
        if width == 0 || height == 0 {
            return self
        }
        var size: CGSize
        // 根据图像的宽高比和目标尺寸的宽高比，计算缩放后的大小
        if width / height > newSizeWidth / newSizeHeight {
            size = CGSize(width: newSizeHeight * width / height, height: newSizeHeight)
        } else {
            size = CGSize(width: newSizeWidth, height: newSizeWidth * height / width)
        }
        return app_drawImage(size: size)
    }
    
    /// 图像绘制到指定大小的画布上
    public func app_drawImage(size: CGSize) -> UIImage? {
        let drawSize = CGSize(width: floor(size.width), height: floor(size.height))
        UIGraphicsBeginImageContextWithOptions(drawSize, false, self.scale)
        defer { UIGraphicsEndImageContext() }
        self.draw(in: CGRect(x: 0, y: 0, width: drawSize.width, height: drawSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        return newImage
    }
    
    // 缩放图片并返回
    public func imageByScaling(to targetSize: CGSize) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(targetSize, false, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }
        self.draw(in: CGRect(origin: .zero, size: targetSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    
    /// 从原始图像中裁剪出指定区域的子图
    public func image(at rect: CGRect) -> UIImage? {
        guard let croppedCGImage = cgImage?.cropping(to: rect) else { return nil }
        return UIImage(cgImage: croppedCGImage)
    }

    
    /// 裁剪指定区域
    public func cropped(to rect: CGRect) -> UIImage {
        UIGraphicsBeginImageContext(rect.size)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else {
            return self
        }
        context.translateBy(x: -rect.minX, y: -rect.minY)
        self.draw(at: .zero)
        if let croppedImage = UIGraphicsGetImageFromCurrentImageContext() {
            return croppedImage
        } else {
            return self
        }
    }
    
    //裁剪图片
    public func croppedImage(_ bound: CGRect) -> UIImage? {
        guard self.size.width > bound.origin.x else {
            print("Your cropping X coordinate is larger than the image width")
            return nil
        }
        guard self.size.height > bound.origin.y else {
            print("Your cropping Y coordinate is larger than the image height")
            return nil
        }
        let scaledBounds: CGRect = CGRect(x: bound.x * self.scale, y: bound.y * self.scale, width: bound.w * self.scale, height: bound.h * self.scale)
        let imageRef = self.cgImage?.cropping(to: scaledBounds)
        let croppedImage: UIImage = UIImage(cgImage: imageRef!, scale: self.scale, orientation: UIImage.Orientation.up)
        return croppedImage
    }
    
    /// Returns resized image with width. Might return low quality
    /// 按指定宽度调整图像大小，并保持其纵横比
    public func resizeWithWidth(_ width: CGFloat) -> UIImage {
        let aspectSize = CGSize (width: width, height: aspectHeightForWidth(width))

        UIGraphicsBeginImageContext(aspectSize)
        self.draw(in: CGRect(origin: CGPoint.zero, size: aspectSize))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return img!
    }

    /// Returns resized image with height. Might return low quality
    /// 指定高度调整图像大小，并保持其纵横比
    public func resizeWithHeight(_ height: CGFloat) -> UIImage {
        let aspectSize = CGSize (width: aspectWidthForHeight(height), height: height)

        UIGraphicsBeginImageContext(aspectSize)
        self.draw(in: CGRect(origin: CGPoint.zero, size: aspectSize))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return img!
    }

    /// 根据宽按比例调整比例
    public func aspectHeightForWidth(_ width: CGFloat) -> CGFloat {
        return (width * self.size.height) / self.size.width
    }
    /// 根据高按比例调整比例
    public func aspectWidthForHeight(_ height: CGFloat) -> CGFloat {
        return (height * self.size.width) / self.size.height
    }
}

class CountedColor {
    let color: UIColor
    let count: Int
    
    init(color: UIColor, count: Int) {
        self.color = color
        self.count = count
    }
}


extension UIImage {
    
    fileprivate func resize(to newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 2)
        draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result!
    }
    
    /// 根据颜色和SIZE生成图片
    public class func generateImage(withColor color: UIColor, size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
        return image
    }
    
    ///取图片色系 background背景色 primary主色调 secondary次要颜色 detail内容颜色
    public func colors(scaleDownSize: CGSize? = nil) -> (background: UIColor, primary: UIColor, secondary: UIColor, detail: UIColor) {
        let cgImage: CGImage
        
        if let scaleDownSize = scaleDownSize {
            cgImage = resize(to: scaleDownSize).cgImage!
        } else {
            let ratio = size.width / size.height
            let r_width: CGFloat = 250
            cgImage = resize(to: CGSize(width: r_width, height: r_width / ratio)).cgImage!
        }
        
        let width = cgImage.width
        let height = cgImage.height
        let bytesPerPixel = 4
        let bytesPerRow = width * bytesPerPixel
        let bitsPerComponent = 8
        let randomColorsThreshold = Int(CGFloat(height) * 0.01)
        let blackColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        let whiteColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let raw = malloc(bytesPerRow * height)
        let bitmapInfo = CGImageAlphaInfo.premultipliedFirst.rawValue
        let context = CGContext(data: raw, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)))
        let data = UnsafePointer<UInt8>(context?.data?.assumingMemoryBound(to: UInt8.self))
        let imageBackgroundColors = NSCountedSet(capacity: height)
        let imageColors = NSCountedSet(capacity: width * height)
        
        let sortComparator: (CountedColor, CountedColor) -> Bool = { (a, b) -> Bool in
            return a.count <= b.count
        }
        
        for x in 0..<width {
            for y in 0..<height {
                let pixel = ((width * y) + x) * bytesPerPixel
                let color = UIColor(
                    red:   CGFloat((data?[pixel+1])!) / 255,
                    green: CGFloat((data?[pixel+2])!) / 255,
                    blue:  CGFloat((data?[pixel+3])!) / 255,
                    alpha: 1
                )
                
                if x >= 5 && x <= 10 {
                    imageBackgroundColors.add(color)
                }
                
                imageColors.add(color)
            }
        }
        
        var sortedColors = [CountedColor]()
        
        for color in imageBackgroundColors {
            guard let color = color as? UIColor else { continue }
            
            let colorCount = imageBackgroundColors.count(for: color)
            
            if randomColorsThreshold <= colorCount  {
                sortedColors.append(CountedColor(color: color, count: colorCount))
            }
        }
        
        sortedColors.sort(by: sortComparator)
        
        var proposedEdgeColor = CountedColor(color: blackColor, count: 1)
        
        if let first = sortedColors.first { proposedEdgeColor = first }
        
        if proposedEdgeColor.color.isBlackOrWhite && !sortedColors.isEmpty {
            for countedColor in sortedColors where CGFloat(countedColor.count / proposedEdgeColor.count) > 0.3 {
                if !countedColor.color.isBlackOrWhite {
                    proposedEdgeColor = countedColor
                    break
                }
            }
        }
        
        let imageBackgroundColor = proposedEdgeColor.color
        let isDarkBackgound = imageBackgroundColor.isDark
        
        sortedColors.removeAll()
        
        for imageColor in imageColors {
            guard let imageColor = imageColor as? UIColor else { continue }
            
            let color = imageColor.color(0.15)
            
            if color.isDark == !isDarkBackgound {
                let colorCount = imageColors.count(for: color)
                sortedColors.append(CountedColor(color: color, count: colorCount))
            }
        }
        
        sortedColors.sort(by: sortComparator)
        
        var primaryColor, secondaryColor, detailColor: UIColor?
        
        for countedColor in sortedColors {
            let color = countedColor.color
            
            if primaryColor == nil &&
                color.isContrasting(with: imageBackgroundColor) {
                primaryColor = color
            } else if secondaryColor == nil &&
                        primaryColor != nil &&
                        primaryColor!.isDistinct(from: color) &&
                        color.isContrasting(with: imageBackgroundColor) {
                secondaryColor = color
            } else if secondaryColor != nil &&
                        (secondaryColor!.isDistinct(from: color) &&
                            primaryColor!.isDistinct(from: color) &&
                            color.isContrasting(with: imageBackgroundColor)) {
                detailColor = color
                break
            }
        }
        
        free(raw)
        
        return (
            imageBackgroundColor,
            primaryColor   ?? (isDarkBackgound ? whiteColor: blackColor),
            secondaryColor ?? (isDarkBackgound ? whiteColor: blackColor),
            detailColor    ?? (isDarkBackgound ? whiteColor: blackColor))
    }
    ///取图片上一点颜色
    public func color(at point: CGPoint, completion: @escaping (UIColor?) -> Void) {
        let size = self.size
        let cgImage = self.cgImage
        
        DispatchQueue.global(qos: .userInteractive).async {
            let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            guard let imgRef = cgImage,
                  let dataProvider = imgRef.dataProvider,
                  let dataCopy = dataProvider.data,
                  let data = CFDataGetBytePtr(dataCopy), rect.contains(point) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            let pixelInfo = (Int(size.width) * Int(point.y) + Int(point.x)) * 4
            let red = CGFloat(data[pixelInfo]) / 255.0
            let green = CGFloat(data[pixelInfo + 1]) / 255.0
            let blue = CGFloat(data[pixelInfo + 2]) / 255.0
            let alpha = CGFloat(data[pixelInfo + 3]) / 255.0
            
            DispatchQueue.main.async {
                completion(UIColor(red: red, green: green, blue: blue, alpha: alpha))
            }
        }
    }
    
    @available(iOS 13.0, *)
    public static func symbol(_ systemName:String, size: CGFloat = 12, color: UIColor = .white) -> UIImage?{
        let config = UIImage.SymbolConfiguration(pointSize: size)
        return UIImage(systemName: systemName, withConfiguration: config)?.withTintColor(color, renderingMode: .alwaysOriginal)
    }

}

public enum gradientColorDirection {
    /// 从左到右
    case left2Right
    /// 从上到下
    case top2Bottom
    /// 从左上角到右下角
    case leftTop2RightBottom
}

public extension UIImage {
    
    /// 渐变色
    class func app_gradientColor(size: CGSize, colors: [UIColor], direction: gradientColorDirection = .left2Right) -> UIImage? {
        
        if colors.count < 2 {
            return nil
        }
        
        var _colors = [CGColor]()
        colors.forEach { color in
            _colors.append(color.cgColor)
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRectMake(0, 0, size.width, size.height) // 设置渐变色的大小
        gradientLayer.colors = _colors // 设置渐变色的颜色数组
        
        switch direction {
            case .left2Right:
                gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
                gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
            case .top2Bottom:
                gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
                gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
            case .leftTop2RightBottom:
                gradientLayer.startPoint = CGPoint(x: 0, y: 0)
                gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        }
        
        UIGraphicsBeginImageContextWithOptions(gradientLayer.bounds.size, gradientLayer.isOpaque, 0.0)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    convenience init(app_renderColor:String, size: CGSize) {
        self.init(app_renderColor: UIColor(hexString: app_renderColor), size: size)
        
    }
    convenience init(app_renderColor:UIColor?, size: CGSize) {
        self.init()
        let color = app_renderColor ?? .black
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
        self.init(cgImage: image.cgImage!)
    }
    
    /// 水平翻转
    func app_vMirror() -> UIImage? {
        var transform = CGAffineTransform.identity
        transform = transform.translatedBy(x: 0, y: self.size.height)
        transform = transform.scaledBy(x: 1, y: -1)
        return _redrawImage(transform)
    }
    /// 垂直翻转
    func app_hMirror() -> UIImage? {
        var transform = CGAffineTransform.identity
        transform = transform.translatedBy(x: self.size.width, y: 0)
        transform = transform.scaledBy(x: -1, y: 1)
        return _redrawImage(transform)
    }
    
    func app_fixOrientation() -> UIImage? {
        if self.imageOrientation == .up {
            return self
        }
        
        var transform = CGAffineTransform.identity
        
        switch self.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: CGFloat.pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: self.size.height)
            transform = transform.rotated(by: -CGFloat.pi / 2)
        default:
            break
        }
        
        switch self.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: self.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default:
            break
        }
        
        return _redrawImage(transform)
    }
    
    private func _redrawImage(_ transform: CGAffineTransform) -> UIImage? {
        if let cgImage = self.cgImage,
           let colorSpace = cgImage.colorSpace {
            
           let ctx = CGContext(data: nil,
                               width: Int(self.size.width),
                               height: Int(self.size.height),
                               bitsPerComponent: cgImage.bitsPerComponent,
                               bytesPerRow: 0,
                               space: colorSpace,
                               bitmapInfo: cgImage.bitmapInfo.rawValue)
            
            guard let ctx else {
                return nil
            }
            
            ctx.concatenate(transform)
            
            switch self.imageOrientation {
            case .left, .leftMirrored, .right, .rightMirrored:
                ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: self.size.height, height: self.size.width))
            default:
                ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
            }
            
            if let cgimg = ctx.makeImage() {
                let img = UIImage(cgImage: cgimg)
                return img
            }
        }
        return nil
    }

    
    /// 对图片进行旋转
    /// - Parameter degrees: 直接传入度数
    func app_rotate(byDegrees degrees: CGFloat, targetSize: CGSize? = nil) -> UIImage {
        let radians = degrees * .pi / 180.0
        let newSize = rotatedSize(withRadians: radians)
           
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!

        context.translateBy(x: newSize.width / 2.0, y: newSize.height / 2.0)
        context.rotate(by: radians)

        self.draw(in: CGRect(x: -self.size.width / 2.0, y: -self.size.height / 2.0, width: self.size.width, height: self.size.height))

        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return rotatedImage ?? UIImage()
    }
    
    private func rotatedSize(withRadians radians: CGFloat) -> CGSize {
        let rotatedRect = CGRect(origin: .zero, size: self.size)
            .applying(CGAffineTransform(rotationAngle: radians))
        return CGSize(width: abs(rotatedRect.width), height: abs(rotatedRect.height))
    }
    
    /// 检测图片内的矩形边框(左上、右上、右下、左下)
    func app_detectRectangle() -> (leftTop: CGPoint, rightTop: CGPoint, rightBottom: CGPoint, leftBottom: CGPoint)? {
        let detectorOptions = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        guard let detector = CIDetector(ofType: CIDetectorTypeRectangle, context: nil, options: detectorOptions) else {
            fatalError("Failed to create CIDetector.")
        }
        // 获取矩形区域数组, 这里一定要先将图片垂直翻转后再检测
        if let cgImage = self.app_vMirror()?.cgImage {
            let image = CIImage(cgImage: cgImage)
            let rectangles = detector.features(in: image)
            if let rectangle = rectangles.first as? CIRectangleFeature {
//                return (rectangle.topLeft,rectangle.topRight,rectangle.bottomRight,rectangle.bottomLeft)
                return (rectangle.bottomLeft,rectangle.bottomRight,rectangle.topRight,rectangle.topLeft)
            }
        }
        return nil
    }
    
    /// 透视校正裁剪
    func app_perspectiveCorp(points: [CGPoint], targetSize: CGSize) -> UIImage? {
        
        guard points.count == 4, let image = self.app_vMirror() else {
            return nil
        }

        // Calculate the size of the cropped image
        let minX = points.min(by: { $0.x < $1.x })!.x
        let maxX = points.max(by: { $0.x < $1.x })!.x
        let minY = points.min(by: { $0.y < $1.y })!.y
        let maxY = points.max(by: { $0.y < $1.y })!.y
        let croppedWidth = maxX - minX
        let croppedHeight = maxY - minY

        // Create a CIImage from the UIImage
        guard let ciImage = CIImage(image: image) else {
            return nil
        }

        // Create four points representing the corners of the cropped image
        let topLeft = CIVector(x: points[0].x, y: points[0].y)
            let topRight = CIVector(x: points[1].x, y: points[1].y)
            let bottomRight = CIVector(x: points[2].x, y: points[2].y)
            let bottomLeft = CIVector(x: points[3].x, y: points[3].y)

        // Create a CIFilter for perspective correction
        let perspectiveCorrectionFilter = CIFilter(name: "CIPerspectiveCorrection")!
        perspectiveCorrectionFilter.setValue(ciImage, forKey: kCIInputImageKey)
        perspectiveCorrectionFilter.setValue(topLeft, forKey: "inputTopLeft")
        perspectiveCorrectionFilter.setValue(topRight, forKey: "inputTopRight")
        perspectiveCorrectionFilter.setValue(bottomRight, forKey: "inputBottomRight")
        perspectiveCorrectionFilter.setValue(bottomLeft, forKey: "inputBottomLeft")

        // Apply the perspective correction
        guard let outputCIImage = perspectiveCorrectionFilter.outputImage else {
            return nil
        }

        // Calculate the scale factor for resizing
        var scale: CGFloat = 1.0
        if croppedWidth > croppedHeight {
            scale = targetSize.width / croppedWidth
        } else {
            scale = targetSize.height / croppedHeight
        }

        // Create a CGAffineTransform for scaling
        let scaleTransform = CGAffineTransform(scaleX: scale, y: scale)

        // Apply scaling to the output image
        let scaledCIImage = outputCIImage.transformed(by: scaleTransform)

        // Create a CIContext
        let context = CIContext(options: nil)

        // Convert the CIImage to a CGImage
        guard let outputCGImage = context.createCGImage(scaledCIImage, from: scaledCIImage.extent) else {
            return nil
        }

        // Create a UIImage from the CGImage and flip along the X-axis
        let croppedAndFlippedImage = UIImage(cgImage: outputCGImage, scale: image.scale, orientation: .upMirrored)
        
        // 重新绘制，为了解决水平翻转问题
        UIGraphicsBeginImageContextWithOptions(targetSize, false, image.scale)
        let currentContext = UIGraphicsGetCurrentContext()
        currentContext?.translateBy(x: 0, y: targetSize.height)
        currentContext?.scaleBy(x: 1, y: -1)
        currentContext?.draw(croppedAndFlippedImage.cgImage!, in: CGRect(origin: .zero, size: targetSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
    /// 图像是否具有 Alpha 通道
    func hasAlphaChannel() -> Bool {
        guard let alphaInfo = cgImage?.alphaInfo else {
            return false
        }
        
        if alphaInfo == .premultipliedLast {
            if let colorSpace = cgImage?.colorSpace,
               let spaceName = colorSpace.name {
                let hasAlphaChannel = spaceName != CGColorSpace.displayP3
                return hasAlphaChannel
            }
            return true
        }
        
        return alphaInfo == .first ||
               alphaInfo == .last ||
               alphaInfo == .premultipliedFirst
    }

}


public extension UIImage {
    
    // MARK:  图片转Data
    func imageToData() -> Data? {
        if self.hasAlphaChannel() {
            return self.pngData()
        } else {
            return self.jpegData(compressionQuality: 1)
        }
    }
}


// MARK:  水印
public extension UIImage {
    
    // 传入图片 设置为居中底部的水印
    func addWatermark(image: UIImage, _ waterScale: CGFloat = 1.0) -> UIImage? {
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        draw(in: CGRect(origin: .zero, size: size))
        
        // 计算水印图片的大小
        let waterW = size.width * waterScale
        let watermarkSize = CGSize(width: waterW, height: waterW * image.size.height / image.size.width)
        // 计算水印图片的位置
        let watermarkRect = CGRect(x: (size.width - watermarkSize.width) / 2,
                                   y: size.height - watermarkSize.height - 20,
                                   width: watermarkSize.width,
                                   height: watermarkSize.height)

        
        image.draw(in: watermarkRect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }

}

public extension UIImage {
    // 图片透明度
    public func withAlpha(_ alpha: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        guard let context = UIGraphicsGetCurrentContext(), let cgImage = self.cgImage else { return nil }
        
        let rect = CGRect(origin: .zero, size: size)
        context.scaleBy(x: 1.0, y: -1.0)
        context.translateBy(x: 0.0, y: -rect.size.height)
        context.setBlendMode(.multiply)
        context.setAlpha(alpha)
        context.draw(cgImage, in: rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
