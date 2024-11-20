//
//  UIView+HUD.swift
//  HUD-Swift_Example
//
//  Created by CNCEMN188807 on 2024/11/20.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import HUD_Swift

extension UIView {

    /// 显示自定义loading
    /// - Parameters:
    ///   - text: Loading文本
    ///   - imageName: 图片名称
    ///   - imageSize: 图片大小
    ///   - marginTop: 距离顶部间距
    public func showLoading(_ text: String = "",
                            image: UIImage? = UIImage(named: "loading/loading"),
                            imageSize: CGSize = CGSize(width: 54, height: 54),
                            marginTop: CGFloat = 0) {
        let loadingView = HUDLoadingView(text: text, imageSize: imageSize)
        loadingView.backgroundColor = .clear
        loadingView.imageView.image = image
        HUD.showLoadingHUD(loadingView,
                           for: self,
                           maskColor: .clear,
                           edgeInsets: UIEdgeInsets(top: marginTop, left: 0, bottom: 0, right: 0))
    }
    
    /// 隐藏loading
    public func hiddenLoading() {
        HUD.hiddenLoadingHUD(for: self)
    }
    
    /// 显示骨架屏
    /// - Parameters:
    ///   - imageName: 骨架屏图片Name
    ///   - padding: 图片距离骨架屏的内边距
    ///   - marginTop: 距离顶部间距
    /// - Returns: HUDSkeletonLoadingView
    @discardableResult
    public func showSkeletonLoading(image: UIImage?,
                                    padding: UIEdgeInsets = .zero,
                                    marginTop: CGFloat = 0) -> HUDSkeletonLoadingView {
        let skeletonView = HUDSkeletonLoadingView()
        skeletonView.imageView.image = image
        skeletonView.padding = padding
        HUD.showSkeletonHUD(skeletonView, for: self, edgeInsets: UIEdgeInsets(top: marginTop, left: 0, bottom: 0, right: 0))
        return skeletonView
    }
    
    /// 移除view上所有的骨架屏
    public func hiddenSkeletonLoading() {
        HUD.hiddenSkeletonHUD(for: self)
    }
    
    /// 显示自定义toast
    /// - Parameters:
    ///   - text: 提示文本
    ///   - duration: 提示时间
    ///   - filterEvent: 是否拦截事件
    ///   - edge: edge
    ///   - dismisssHandler: toast消失回调
    public func showToast(_ text: String,
                          image: UIImage? = nil,
                          duration: Int = 2,
                          position: HUDPosition = .center(offsetX: 0, offsetY: 0),
                          backgroundColor: UIColor? = .black,
                          filterEvent: Bool = false,
                          edgeInsets: UIEdgeInsets = .zero,
                          dismisssHandler: (() -> Void)? = nil) {
        let toastView = HUDToastView(text: text, image: image)
        toastView.backgroundColor = backgroundColor
        HUD.showToastHUD(toastView,
                         for: self,
                         duration: duration,
                         position: position,
                         maskColor: .clear,
                         filterEvent: filterEvent,
                         edgeInsets: edgeInsets,
                         dismisssHandler: dismisssHandler
        )
    }
    
    /// 隐藏自定义toast
    public func hiddenToast() {
        HUD.hiddenToastHUD(for: self)
    }
    
    /// 隐藏所有的自定义loading和toast
    public func hiddenAllHUD() {
        HUD.hiddenAllHUD(for: self)
    }
}
