//
//  HUD.swift
//  JCXX
//
//  Created by gavin on 2023/7/20.
//

import UIKit
import SnapKit

/// toast 位置
public enum HUDPosition {
    case center(offsetX: CGFloat = 0, offsetY: CGFloat = 0)
    case top(top: CGFloat)
    case bottom(bottom: CGFloat)
}

/// HUD类型
public enum HUDType: String {
    
    /// loading
    case loading
    
    /// toast
    case toast
    
    /// 骨架屏
    case skeleton
}

public class HUD: UIView {
    
    /// hud类型
    public var hudType: HUDType
    
    var dismissTimer: GCDTimer?
    
    public init(hudType: HUDType) {
        self.hudType = hudType
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        debugPrint("HUD deinit")
    }
}

extension HUD {
    
    /// loading
    /// - Parameters:
    ///   - view: loading的目标view
    ///   - loadingView: loadingView
    ///   - maskColor: mask背景
    ///   - filterEvent: 是否拦截事件
    ///   - edgeInsets: hud边距
    /// - Returns: HUD
    @discardableResult
    public static func showLoadingHUD(_ loadingView: UIView = HUDLoadingView(),
                                      for view: UIView,
                                      maskColor: UIColor? = .clear,
                                      filterEvent: Bool = true,
                                      edgeInsets: UIEdgeInsets = .zero) -> HUD {
        self.hiddenLoadingHUD(for: view)
        
        let hud = HUD(hudType: .loading)
        hud.backgroundColor = maskColor
        hud.isUserInteractionEnabled = filterEvent
        view.addSubview(hud)
        hud.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(edgeInsets)
        }
        hud.addSubview(loadingView)
        loadingView.snp.remakeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        return hud
    }
    
    /// 移除view上所有的loadingHud
    public static func hiddenLoadingHUD(for view: UIView) {
        guard let loadingHuds = self.allHud(for: view, type: .loading) else { return }
        for hud in loadingHuds {
            self.removeHUD(hud)
        }
    }
    
    /// 显示骨架屏
    /// - Parameters:
    ///   - skeletonView: 骨架屏
    ///   - view: 目标view
    ///   - maskColor: mask背景
    ///   - filterEvent: 是否拦截事件
    ///   - edgeInsets: hud边距
    /// - Returns: HUDSkeletonLoadingView
    @discardableResult
    public static func showSkeletonHUD<T: UIView>(_ skeletonView: T = HUDSkeletonLoadingView(),
                                                  for view: UIView,
                                                  maskColor: UIColor? = .clear,
                                                  filterEvent: Bool = true,
                                                  edgeInsets: UIEdgeInsets = .zero) -> T {
        self.hiddenSkeletonHUD(for: view)
        
        let hud = HUD(hudType: .skeleton)
        hud.backgroundColor = maskColor
        hud.isUserInteractionEnabled = filterEvent
        view.addSubview(hud)
        hud.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(edgeInsets)
        }
        hud.addSubview(skeletonView)
        skeletonView.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        return skeletonView
    }
    
    /// 移除view上所有的骨架屏
    public static func hiddenSkeletonHUD(for view: UIView) {
        guard let skeletonHuds = self.allHud(for: view, type: .skeleton) else { return }
        for hud in skeletonHuds {
            self.removeHUD(hud)
        }
    }
    
    /// toast
    /// - Parameters:
    ///   - view: loading的目标view
    ///   - toastView: toastView
    ///   - maskColor: mask背景
    ///   - filterEvent: 是否拦截事件
    ///   - edgeInsets: hud边距
    /// - Returns: HUD
    @discardableResult
    public static func showToastHUD(_ toastView: UIView = HUDToastView(text: ""),
                                    for view: UIView,
                                    duration: Int = 2,
                                    position: HUDPosition = .center(offsetX: 0, offsetY: 0),
                                    maskColor: UIColor? = .clear,
                                    filterEvent: Bool = false,
                                    edgeInsets: UIEdgeInsets = .zero,
                                    dismisssHandler: (() -> Void)? = nil) -> HUD {
        self.hiddenToastHUD(for: view)
        
        let hud = HUD(hudType: .toast)
        hud.backgroundColor = maskColor
        hud.isUserInteractionEnabled = filterEvent
        view.addSubview(hud)
        hud.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(edgeInsets)
        }
        hud.addSubview(toastView)
        switch position {
        case let .center(x, y):
            toastView.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview().offset(x)
                make.centerY.equalToSuperview().offset(y)
            }
            
        case let .top(top):
            toastView.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().offset(top)
            }
            
        case let .bottom(bottom):
            toastView.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().offset(bottom)
            }
        }
        // duration秒后自动移除
        weak var wkHud = hud
        hud.dismissTimer = GCDTimer(interval: .seconds(duration), repeats: false, handler: {
            wkHud?.removeFromSuperview()
        })
        hud.dismissTimer?.start()
        return hud
    }
    
    /// 移除view上所有的toastHud
    public static func hiddenToastHUD(for view: UIView) {
        guard let loadingHuds = self.allHud(for: view, type: .toast) else { return }
        for hud in loadingHuds {
            self.removeHUD(hud)
        }
    }
    
    /// 获取view上的HUD
    public static func allHud(for view: UIView, type: HUDType? = nil, name: String? = nil) -> [HUD]? {
        guard let allHuds = view.subviews.filter({ subview in
            return subview.isKind(of: HUD.self)
        }) as? [HUD] else {
            return nil
        }
        let filterHuds = allHuds.filter { hud in
            return hud.hudType == type
        }
        return filterHuds
    }
    
    /// 移除view上所有的hud
    public static func hiddenAllHUD(for view: UIView) {
        if let huds = self.allHud(for: view) {
            for hud in huds {
                self.removeHUD(hud)
            }
        }
    }
    
    /// 移除hud
    public static func removeHUD(_ hud: HUD) {
        for subView in hud.subviews {
            subView.removeFromSuperview()
        }
        hud.removeFromSuperview()
    }
}
