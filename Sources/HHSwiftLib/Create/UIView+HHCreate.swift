//
//  UIView+HHCreate.swift
//  HHSwiftLib
//
//  Created by MAC on 2024/3/12.
//

import UIKit
import SnapKit
import SwiftUI

@available(iOS 13.0, *)
public func wrapperSwiftUI(content: some View) -> UIView{
    return UIHostingController(rootView: content).view.hh_clearBackgroundColor()
}

private var topNameKey: UInt8 = 0
private var rightNameKey: UInt8 = 0
private var bottomNameKey: UInt8 = 0
private var leftNameKey: UInt8 = 0

public extension UIView {
    
    @discardableResult
    func hh_layout(superView: UIView, _ closure: (_ make: ConstraintMaker) -> Void) -> Self {
        superView.addSubview(self)
        self.snp.makeConstraints(closure)
        return self
    }
    @discardableResult
    func hh_layout(superView: UIView, _ frame: CGRect) -> Self {
        superView.addSubview(self)
        self.frame = frame
        return self
    }
    @discardableResult
    func hh_layout(superView: UIView) -> Self {
        superView.addSubview(self)
        return self
    }
    @discardableResult
    func hh_setFrame(_ frame: CGRect) -> Self {
        self.frame = frame
        return self
    }
    @discardableResult
    func hh_setBounds(_ bounds: CGRect) -> Self {
        self.bounds = bounds
        return self
    }
    
    @discardableResult
    func hh_setBackgroundColor(_ hexColor: String) -> Self {
        backgroundColor = UIColor(hexString: hexColor)
        return self
    }
    @discardableResult
    func hh_setBackgroundColor(_ hexColor: UIColor?) -> Self {
        backgroundColor = hexColor
        return self
    }
    @discardableResult
    func hh_clearBackgroundColor() -> Self {
        backgroundColor = .clear
        return self
    }
    
    @discardableResult
    func hh_setAlpha(_ alpha: CGFloat) -> Self {
        self.alpha = alpha
        return self
    }
    
    @discardableResult
    func hh_setHidden(_ hidden: Bool) -> Self {
        self.isHidden = hidden
        return self
    }
    
    @discardableResult
    func hh_setUserInteractionEnabled(_ enabled: Bool) -> Self {
        self.isUserInteractionEnabled = enabled
        return self
    }
    
    @discardableResult
    func hh_bringToFront() -> Self {
        self.superview?.bringSubviewToFront(self)
        return self
    }
    
    @discardableResult
    func hh_sendToBack() -> Self {
        self.superview?.sendSubviewToBack(self)
        return self
    }
    
    
    @discardableResult
    func hh_setCornerRadius(_ cornerRadius: CGFloat, masksToBounds: Bool = true) -> Self {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = masksToBounds
        return self
    }
    @discardableResult
    func hh_setClipsToBounds(_ clipsToBounds: Bool = true) -> Self {
        self.clipsToBounds = clipsToBounds
        return self
    }
    @discardableResult
    func hh_setMaskedCorners(_ corners: CACornerMask = [.layerMinXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMinYCorner,.layerMaxXMaxYCorner]) -> Self {
        layer.maskedCorners = corners
        return self
    }

    @discardableResult
    func hh_setContentMode(_ contentMode: ContentMode) -> Self {
        self.contentMode = contentMode
        return self
    }
    
    @discardableResult
    func hh_setBorderColor(_ color: String, alpha: CGFloat = 1) -> Self {
        self.layer.borderColor = UIColor(hexString: color, alpha: alpha)?.cgColor
        return self
    }
    @discardableResult
    func hh_setBorderColor(_ color: UIColor) -> Self {
        self.layer.borderColor = color.cgColor
        return self
    }
    @discardableResult
    func hh_setBorderWidth(_ width: CGFloat) -> Self {
        self.layer.borderWidth = width
        return self
    }
}

public extension UIButton {
    
    enum MCImagePosition {
        case left, right, top, bottom
    }
    
    @discardableResult
    func hh_setTitle(_ title: String, _ state: UIControl.State = .normal) -> Self {
        setTitle(title, for: state)
        return self
    }
    
    @discardableResult
    func hh_setTitleColor(_ color: String, alpha: CGFloat = 1, state: UIControl.State = .normal) -> Self {
        setTitleColor(UIColor(hexString: color, alpha: alpha), for: state)
        return self
    }
    @discardableResult
    func hh_setTitleColor(_ color: UIColor?, _ state: UIControl.State = .normal) -> Self {
        setTitleColor(color, for: state)
        return self
    }
    
    @discardableResult
    func hh_setImage(_ imageName: String, _ state: UIControl.State = .normal, renderColor: UIColor? = nil) -> Self {
        var image = UIImage(named: imageName)
        if let renderColor {
            if #available(iOS 13.0, *) {
                image = image?.withTintColor(renderColor, renderingMode: .alwaysOriginal)
            } else {
            }
        }
        setImage(image, for: state)
        return self
    }
    
    @discardableResult
    func hh_setImage(_ image: UIImage?, _ state: UIControl.State = .normal, renderColor: UIColor? = nil) -> Self {
        var _image = image
        if let image, let renderColor {
            _image = image.withTintColor(renderColor, renderingMode: .alwaysOriginal)
        }
        setImage(_image, for: state)
        return self
    }
    @discardableResult
    func hh_setImageNil(_ state: UIControl.State = .normal, renderColor: UIColor? = nil) -> Self {
        setImage(nil, for: state)
        return self
    }
    
    @discardableResult
    func hh_setFont(_ font: UIFont?) -> Self {
        titleLabel?.font = font
        return self
    }
    @discardableResult
    func hh_setFontSize(_ size: CGFloat) -> Self {
        titleLabel?.font = .systemFont(ofSize: size)
        return self
    }
    
    @discardableResult
    func hh_setBackgroundImage(_ imageName: String, _ state: UIControl.State = .normal) -> Self {
        setBackgroundImage(UIImage(named: imageName), for: state)
        return self
    }
    @discardableResult
    func hh_setBackgroundImage(_ image: UIImage?, _ state: UIControl.State = .normal) -> Self {
        setBackgroundImage(image, for: state)
        return self
    }
    
    @discardableResult
    func hh_setAdjustsImageWhenDisabled(_ adjusts: Bool) -> Self {
        adjustsImageWhenDisabled = adjusts
        return self
    }
    @discardableResult
    func hh_setAdjustsImageWhenHighlighted(_ adjusts: Bool) -> Self {
        adjustsImageWhenHighlighted = adjusts
        return self
    }
    
    @discardableResult
    func hh_setImagePosition(_ position: MCImagePosition, spacing: CGFloat) -> Self {
        guard let imageSize = imageView?.image?.size,
            let text = titleLabel?.text,
            let font = titleLabel?.font else {
            return self
        }

        let titleSize = text.size(withAttributes: [.font: font])

        let imageOffsetX = (imageSize.width + titleSize.width) / 2 - imageSize.width / 2// image中心移动的x距离
        let imageOffsetY = imageSize.height / 2 + spacing / 2// image中心移动的y距离
        let labelOffsetX = (imageSize.width + titleSize.width / 2) - (imageSize.width + titleSize.width) / 2// label中心移动的x距离
        let labelOffsetY = titleSize.height / 2 + spacing / 2// label中心移动的y距离

        let tempWidth = max(titleSize.width, imageSize.width)
        let changedWidth = titleSize.width + imageSize.width - tempWidth
        let tempHeight = max(titleSize.height, imageSize.height)
        let changedHeight = titleSize.height + imageSize.height + spacing - tempHeight

        switch position {
        case .top:
            imageEdgeInsets = UIEdgeInsets(top: -imageOffsetY, left: imageOffsetX, bottom: imageOffsetY, right: -imageOffsetX)
            titleEdgeInsets = UIEdgeInsets(top: labelOffsetY, left: -labelOffsetX, bottom: -labelOffsetY, right: labelOffsetX)
            contentEdgeInsets = UIEdgeInsets(top: imageOffsetY, left: -0.5 * changedWidth, bottom: changedHeight-imageOffsetY, right: -0.5 * changedWidth)

        case .bottom:
            imageEdgeInsets = UIEdgeInsets(top: imageOffsetY, left: imageOffsetX, bottom: -imageOffsetY, right: -imageOffsetX)
            titleEdgeInsets = UIEdgeInsets(top: -labelOffsetY, left: -labelOffsetX, bottom: labelOffsetY, right: labelOffsetX)
            contentEdgeInsets = UIEdgeInsets(top: changedHeight-imageOffsetY, left: -0.5 * changedWidth, bottom: imageOffsetY, right: -0.5 * changedWidth)

        case .right:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: titleSize.width + 0.5 * spacing, bottom: 0, right: -(titleSize.width + 0.5 * spacing))
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -(imageSize.width + 0.5 * spacing), bottom: 0, right: imageSize.width + spacing * 0.5)
            contentEdgeInsets = UIEdgeInsets(top: 0, left: 0.5 * spacing, bottom: 0, right: 0.5*spacing)

        case .left:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -0.5 * spacing, bottom: 0, right: 0.5 * spacing)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 0.5 * spacing, bottom: 0, right: -0.5 * spacing)
            contentEdgeInsets = UIEdgeInsets(top: 0, left: 0.5 * spacing, bottom: 0, right: 0.5 * spacing)
        }
        return self
    }
    
    @discardableResult
    func hh_enlargeEdge(_ left: CGFloat, _ top: CGFloat, _ right: CGFloat, _ bottom: CGFloat) -> Self {
        objc_setAssociatedObject(self, &topNameKey, NSNumber(value: Float(top)), .OBJC_ASSOCIATION_COPY_NONATOMIC)
        objc_setAssociatedObject(self, &rightNameKey, NSNumber(value: Float(right)), .OBJC_ASSOCIATION_COPY_NONATOMIC)
        objc_setAssociatedObject(self, &bottomNameKey, NSNumber(value: Float(bottom)), .OBJC_ASSOCIATION_COPY_NONATOMIC)
        objc_setAssociatedObject(self, &leftNameKey, NSNumber(value: Float(left)), .OBJC_ASSOCIATION_COPY_NONATOMIC)
        return self
    }
    private func enlargedRect() -> CGRect {
        let topEdge = objc_getAssociatedObject(self, &topNameKey) as? NSNumber
        let rightEdge = objc_getAssociatedObject(self, &rightNameKey) as? NSNumber
        let bottomEdge = objc_getAssociatedObject(self, &bottomNameKey) as? NSNumber
        let leftEdge = objc_getAssociatedObject(self, &leftNameKey) as? NSNumber
        
        if let topEdge = topEdge, let rightEdge = rightEdge, let bottomEdge = bottomEdge, let leftEdge = leftEdge {
            return CGRect(x: bounds.origin.x - CGFloat(leftEdge.floatValue),
                          y: bounds.origin.y - CGFloat(topEdge.floatValue),
                          width: bounds.size.width + CGFloat(leftEdge.floatValue) + CGFloat(rightEdge.floatValue),
                          height: bounds.size.height + CGFloat(topEdge.floatValue) + CGFloat(bottomEdge.floatValue))
        } else {
            return bounds
        }
    }
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if alpha <= 0.1 || isHidden {
            return nil
        }
        
        let rect = enlargedRect()
        if rect.equalTo(bounds) {
            return super.hitTest(point, with: event)
        }
        
        return rect.contains(point) ? self : nil
    }
}

private var UIControlClickDisposable: String = ""
public extension UIControl {

    private struct hh_associatedKeys {
        static var hh_click_block_key = UnsafeRawPointer.init(bitPattern: "hh_click_block_key".hashValue)
    }
    
    @discardableResult
    func hh_clickBlock(_ handler: @escaping ()->()) -> Self{
        guard let key = hh_associatedKeys.hh_click_block_key else { return self}
        objc_setAssociatedObject(self, key, handler, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        self.addTarget(self, action: #selector(hh_clickAction), for: .touchUpInside)
        return self
    }
    
    @objc func hh_clickAction() {
        guard let key = hh_associatedKeys.hh_click_block_key else {return}
        if let action = objc_getAssociatedObject(self, key) as? ()->() {
            action()
        }
    }
    
    @discardableResult
    func hh_setIsSelected(_ isSelected: Bool) -> Self {
        self.isSelected = isSelected
        return self
    }
    @discardableResult
    func hh_setIsHighlighted(_ isHighlighted: Bool) -> Self {
        self.isHighlighted = isHighlighted
        return self
    }
    @discardableResult
    func hh_setIsEnabled(_ isEnabled: Bool) -> Self {
        self.isEnabled = isEnabled
        return self
    }
}

public extension UILabel {
    
    convenience init(text: String?, font: CGFloat, textColor: UIColor?, align: NSTextAlignment = .left) {
        self.init(frame: .zero)
        self.hh_setText(text).hh_setFontSize(font).hh_setTextColor(textColor).hh_setTextAlignment(align)
    }
    convenience init(text: String?, font: UIFont, textColor: UIColor?, align: NSTextAlignment = .left) {
        self.init(frame: .zero)
        self.hh_setText(text).hh_setFont(font).hh_setTextColor(textColor).hh_setTextAlignment(align)
    }
    convenience init(text: String?, font: CGFloat, textColor: String, align: NSTextAlignment = .left) {
        self.init(frame: .zero)
        self.hh_setText(text).hh_setFontSize(font).hh_setTextColor(textColor).hh_setTextAlignment(align)
    }
    convenience init(text: String?, font: UIFont, textColor: String, align: NSTextAlignment = .left) {
        self.init(frame: .zero)
        self.hh_setText(text).hh_setFont(font).hh_setTextColor(textColor).hh_setTextAlignment(align)
    }
    
    @discardableResult
    func hh_setText(_ text: String?) -> Self{
        self.text = text
        return self
    }
    
    @discardableResult
    func hh_setFont(_ font: UIFont) -> Self{
        self.font = font
        return self
    }
    @discardableResult
    func hh_setFontSize(_ fontSize: CGFloat) -> Self{
        self.font = .systemFont(ofSize: fontSize)
        return self
    }

    @discardableResult
    func hh_setTextColor(_ color: String, alpha: CGFloat = 1) -> Self{
        self.textColor = UIColor(hexString: color, alpha: alpha)
        return self
    }
    @discardableResult
    func hh_setTextColor(_ color: UIColor?) -> Self{
        self.textColor = color
        return self
    }
    
    @discardableResult
    func hh_setTextAlignment(_ align: NSTextAlignment) -> Self{
        self.textAlignment = align
        return self
    }
    
    @discardableResult
    func hh_setNumberOfLines(_ lines: Int) -> Self{
        self.numberOfLines = lines
        return self
    }
}

public extension UIImageView {
    
    @discardableResult
    func hh_setImage(_ image: Any?) -> Self{
        guard let image else {
            return self
        }
        if let image = image as? String {
            self.image = UIImage(named: image)

        } else if let image = image as? UIImage {
            self.image = image
        }
        return self
    }
    
    @discardableResult
    func hh_setImageNil() -> Self {
        self.image = nil
        return self
    }
}

public extension UISlider {

    @discardableResult
    func hh_setValue(_ value: Float) -> Self{
        self.value = value
        return self
    }
    
    @discardableResult
    func hh_setMinimumValue(_ value: Float) -> Self{
        self.minimumValue = value
        return self
    }
    @discardableResult
    func hh_setMaximumValue(_ value: Float) -> Self{
        self.maximumValue = value
        return self
    }
    
    @discardableResult
    func hh_setMinimumValueImage(_ image: UIImage?) -> Self{
        self.minimumValueImage = image
        return self
    }
    @discardableResult
    func hh_setMinimumValueImage(_ image: String) -> Self{
        self.minimumValueImage = UIImage(named: image)
        return self
    }
    
    @discardableResult
    func hh_setMaximumValueImage(_ image: UIImage?) -> Self{
        self.maximumValueImage = image
        return self
    }
    @discardableResult
    func hh_setMaximumValueImage(_ image: String) -> Self{
        self.maximumValueImage = UIImage(named: image)
        return self
    }
    
    @discardableResult
    func hh_setIsContinuous(_ isContinuous: Bool) -> Self{
        self.isContinuous = isContinuous
        return self
    }
    
    @discardableResult
    func hh_setMinimumTrackTintColor(_ color: UIColor?) -> Self{
        self.minimumTrackTintColor = color
        return self
    }
    @discardableResult
    func hh_setMinimumTrackTintColor(_ color: String, alpha: CGFloat = 1) -> Self{
        self.minimumTrackTintColor = UIColor(hexString: color, alpha: alpha)
        return self
    }
    
    @discardableResult
    func hh_setMaximumTrackTintColor(_ color: UIColor?) -> Self{
        self.maximumTrackTintColor = color
        return self
    }
    @discardableResult
    func hh_setMaximumTrackTintColor(_ color: String, alpha: CGFloat = 1) -> Self{
        self.maximumTrackTintColor = UIColor(hexString: color, alpha: alpha)
        return self
    }
    
    @discardableResult
    func hh_setThumbTintColor(_ color: String, alpha: CGFloat = 1) -> Self{
        self.thumbTintColor = UIColor(hexString: color, alpha: alpha)
        return self
    }
    @discardableResult
    func hh_setThumbTintColor(_ color: UIColor) -> Self{
        self.thumbTintColor = color
        return self
    }
    
    @discardableResult
    func hh_setThumbImage(_ image: UIImage?, state:  UIControl.State = .normal) -> Self{
        setThumbImage(image, for: state)
        return self
    }
    @discardableResult
    func hh_setThumbImage(_ image: String, state:  UIControl.State = .normal) -> Self{
        setThumbImage(UIImage(named: image), for: state)
        return self
    }
    
    @discardableResult
    func hh_setMinimumTrackImage(_ image: UIImage?, state:  UIControl.State = .normal) -> Self{
        setMinimumTrackImage(image, for: state)
        return self
    }
    @discardableResult
    func hh_setMinimumTrackImage(_ image: String, state:  UIControl.State = .normal) -> Self{
        setMinimumTrackImage(UIImage(named: image), for: state)
        return self
    }
    @discardableResult
    func hh_setMaximumTrackImage(_ image: UIImage?, state:  UIControl.State = .normal) -> Self{
        setMaximumTrackImage(image, for: state)
        return self
    }
    @discardableResult
    func hh_setMaximumTrackImage(_ image: String, state:  UIControl.State = .normal) -> Self{
        setMaximumTrackImage(UIImage(named: image), for: state)
        return self
    }
    
    @discardableResult
    func hh_setTarget(_ changed: @escaping ((_ value: CGFloat) -> Void),
                       changeBegin: ((_ value: CGFloat) -> Void)? = nil,
                       changeEnd: ((_ value: CGFloat) -> Void)? = nil) -> Self {
        
        let target = MCSliderTarget { value in
            changed(CGFloat(value))
        } changeBegin: { value in
            changeBegin?(CGFloat(value))
        } changeEnd: { value in
            changeEnd?(CGFloat(value))
        }

        addTarget(target, action: #selector(MCSliderTarget.valueChanged(_:)), for: .valueChanged)
        addTarget(target, action: #selector(MCSliderTarget.changeBegin(_:)), for: .editingDidBegin)
        addTarget(target, action: #selector(MCSliderTarget.changeEnd(_:)), for: .editingDidEnd)
    
        
        return self
    }
}

public extension UICollectionViewFlowLayout {
    
    @discardableResult
    func hh_setItemSize(_ size: CGSize) -> Self{
        self.itemSize = size
        return self
    }
    
    @discardableResult
    func hh_setMinimumLineSpacing(_ spacing: CGFloat) -> Self{
        self.minimumLineSpacing = spacing
        return self
    }
    @discardableResult
    func hh_setMinimumInteritemSpacing(_ spacing: CGFloat) -> Self{
        self.minimumInteritemSpacing = spacing
        return self
    }
    
    @discardableResult
    func hh_setScrollDirection(_ direction: UICollectionView.ScrollDirection) -> Self{
        self.scrollDirection = direction
        return self
    }
    
}

public extension UIScrollView {
    
    @discardableResult
    func hh_setContentInset(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> Self {
        self.contentInset = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        return self
    }
    @discardableResult
    func hh_setContentSize(_ contentSize: CGSize) -> Self {
        self.contentSize = contentSize
        return self
    }
    @discardableResult
    func hh_setContentOffset(_ contentOffset: CGPoint) -> Self {
        self.contentOffset = contentOffset
        return self
    }
    
    @discardableResult
    func hh_setBounces(_ bounces: Bool) -> Self {
        self.bounces = bounces
        return self
    }
    
    @discardableResult
    func hh_setScrollEnabled(_ enabled: Bool) -> Self {
        self.isScrollEnabled = enabled
        return self
    }
    
    @discardableResult
    func hh_setShowsVerticalScrollIndicator(_ show: Bool) -> Self {
        self.showsVerticalScrollIndicator = show
        return self
    }
    @discardableResult
    func hh_setShowsHorizontalScrollIndicator(_ show: Bool) -> Self {
        self.showsHorizontalScrollIndicator = show
        return self
    }
    @discardableResult
    func hh_hiddenBothScrollIndicator() -> Self {
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        return self
    }
    
    @discardableResult
    func hh_setPagingEnabled(_ enabled: Bool) -> Self {
        self.isPagingEnabled = enabled
        return self
    }
    
    @discardableResult
    func hh_setDelegate(_ delegate: UIScrollViewDelegate?) -> Self {
        self.delegate = delegate
        return self
    }
}

public extension UICollectionView {
    
    convenience init(frame: CGRect, flowLayoutMaker:((_ layout: UICollectionViewFlowLayout) -> Void)) {
        let layout = UICollectionViewFlowLayout()
        flowLayoutMaker(layout)
        self.init(frame: frame, collectionViewLayout: layout)
    }
    
    @discardableResult
    func hh_setDelegate(_ delegate: UICollectionViewDelegate?) -> Self {
        self.delegate = delegate
        return self
    }
    @discardableResult
    func hh_setDelegate(_ delegate: UICollectionViewDelegate & UICollectionViewDataSource) -> Self {
        self.delegate = delegate
        self.dataSource = delegate
        return self
    }
    @discardableResult
    func hh_setDataSource(_ dataSource: UICollectionViewDataSource?) -> Self {
        self.dataSource = dataSource
        return self
    }
    @discardableResult
    func hh_register(_ cellClass: AnyClass?, identifier: String) -> Self {
        self.register(cellClass, forCellWithReuseIdentifier: identifier)
        return self
    }
    @discardableResult
    func hh_register(_ viewClass: AnyClass?, supplementaryViewOfKind: String, identifier: String) -> Self {
        self.register(viewClass, forSupplementaryViewOfKind: supplementaryViewOfKind, withReuseIdentifier: identifier)
        return self
    }
}

public extension UITableView {
    
    // 注册
    
    @discardableResult
    func hh_registerCellClass(_ cellClass: AnyClass, identifier: String) -> Self{
        self.register(cellClass, forCellReuseIdentifier: identifier)
        return self
    }
    @discardableResult
    func hh_registerSectionHeaderFooterClass(_ aClass: AnyClass, identifier: String) -> Self{
        self.register(aClass, forHeaderFooterViewReuseIdentifier: identifier)
        return self
    }
    
    // 代理
    @discardableResult
    func hh_setDelegate(_ delegate: UITableViewDelegate?) -> Self {
        self.delegate = delegate
        return self
    }
    @discardableResult
    func hh_setDelegate(_ delegate: UITableViewDelegate & UITableViewDataSource) -> Self {
        self.delegate = delegate
        self.dataSource = delegate
        return self
    }
    @discardableResult
    func hh_setDataSource(_ dataSource: UITableViewDataSource?) -> Self {
        self.dataSource = dataSource
        return self
    }
    
//    #pragma mark - 行高
    @discardableResult
    func hh_setRowHeight(_ value: CGFloat) -> Self {
        self.rowHeight = value
        return self
    }
    @discardableResult
    func hh_setEstimatedRowHeight(_ value: CGFloat) -> Self {
        self.estimatedRowHeight = value
        return self
    }
    
//    #pragma mark - 区高
    @discardableResult
    func hh_setEstimatedSectionHeaderHeight(_ value: CGFloat) -> Self {
        self.estimatedSectionHeaderHeight = value
        return self
    }
    @discardableResult
    func hh_setEstimatedSectionFooterHeight(_ value: CGFloat) -> Self {
        self.estimatedSectionFooterHeight = value
        return self
    }
    @discardableResult
    func hh_setSectionHeaderHeight(_ value: CGFloat) -> Self {
        self.sectionHeaderHeight = value
        return self
    }
    @discardableResult
    func hh_setSectionFooterHeight(_ value: CGFloat) -> Self {
        self.sectionFooterHeight = value
        return self
    }

//    #pragma mark - 分隔栏
    @discardableResult
    func hh_setSeparatorColor(_ color: String) -> Self {
        self.separatorColor = UIColor(hexString: color)
        return self
    }
    @discardableResult
    func hh_setSeparatorColor(_ color: UIColor?) -> Self {
        self.separatorColor = color
        return self
    }
    @discardableResult
    func hh_setSeparatorStyle(_ style: UITableViewCell.SeparatorStyle) -> Self {
        self.separatorStyle = style
        return self
    }
    @discardableResult
    func hh_setSeparatorStyleNone() -> Self {
        self.separatorStyle = .none
        return self
    }
    @discardableResult
    func hh_setSeparatorInset(_ insets: UIEdgeInsets) -> Self {
        self.separatorInset = insets
        return self
    }

//    #pragma mark - 选择
    @discardableResult
    func hh_setAllowsSelection(_ value: Bool) -> Self {
        self.allowsSelection = value
        return self
    }
    @discardableResult
    func hh_setAllowsMultipleSelection(_ value: Bool) -> Self {
        self.allowsMultipleSelection = value
        return self
    }
    
//    #pragma mark - 表头、表尾
    @discardableResult
    func hh_setTableHeaderView(_ view: UIView?) -> Self {
        self.tableHeaderView = view
        return self
    }
    @discardableResult
    func hh_setTableFooterView(_ view: UIView?) -> Self {
        self.tableFooterView = view
        return self
    }
    @discardableResult
    func hh_setTableHeaderNone() -> Self {
        self.tableHeaderView = nil
        return self
    }
    @discardableResult
    func hh_setTableFooterViewNone() -> Self {
        self.tableFooterView = nil
        return self
    }
    
    @discardableResult
    func hh_setEditing(_ value: Bool) -> Self {
        self.isEditing = value
        return self
    }

}

public extension UITableViewCell {
    @discardableResult
    func hh_setSelectionStyle(_ style: UITableViewCell.SelectionStyle) -> Self {
        self.selectionStyle = style
        return self
    }
    @discardableResult
    func hh_setSelectionStyleNone() -> Self {
        self.selectionStyle = .none
        return self
    }
}

class MCSliderTarget {
    
    let changing: (Float) -> Void
    let changeBegin: (Float) -> Void
    let changeEnd: (Float) -> Void

    init(changing: @escaping (Float) -> Void, changeBegin: @escaping (Float) -> Void, changeEnd: @escaping (Float) -> Void) {
        self.changing = changing
        self.changeBegin = changeBegin
        self.changeEnd = changeEnd
    }

    @objc func valueChanged(_ sender: UISlider) {
        changing(sender.value)
    }
    @objc func changeBegin(_ sender: UISlider) {
        changeBegin(sender.value)
    }
    @objc func changeEnd(_ sender: UISlider) {
        changeEnd(sender.value)
    }
}
