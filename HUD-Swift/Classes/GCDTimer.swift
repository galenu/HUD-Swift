//
//  GCDTimer.swift
//  stick_ios
//
//  Created by CNCEMN188807 on 2023/12/23.
//

import UIKit

/// 基于GCD的timer 不依赖runloop，不用手动释放
public class GCDTimer: NSObject {
        
    public var timer: DispatchSourceTimer?
    
    /// 是否正在倒计时
    public var isRuning = false
    
    /// 初始化GCD的timer
    /// - Parameters:
    ///   - timeInterval: 时间间隔  秒
    ///   - repeats: 是否重复
    ///   - queue: 对应线程
    ///   - block: 回调
    public init(interval: DispatchTimeInterval, repeats: Bool, queue: DispatchQueue = DispatchQueue.main, handler: (() -> Void)? = nil) {
        super.init()
        
        let timer = DispatchSource.makeTimerSource(flags: [], queue: queue)
        self.timer = timer
        self.setInterval(interval, repeats: repeats, handler: handler)
    }
    
    deinit {
        self.invalidate()
    }
    
    public func setInterval(_ interval: DispatchTimeInterval, repeats: Bool, handler: (() -> Void)?) {
        if repeats {
            timer?.schedule(deadline: .now() + interval, repeating: interval)
        } else {
            timer?.schedule(deadline: .now() + interval, repeating: .never)
        }
        timer?.setEventHandler(handler: handler)
    }
    
    /// 开始定时器
    public func start() {
        if !isRuning {
            timer?.resume()
        }
        isRuning = true
    }
    
    /// 暂停定时器
    public func stop() {
        if isRuning {
            timer?.suspend()
        }
        isRuning = false
    }
    
    /// 清除定时器
    public func invalidate() {
        timer?.setEventHandler(handler: nil)
        // suspended状态调用cancel()会崩溃 https://developer.apple.com/forums/thread/15902
        start()
        timer?.cancel()
        timer = nil
    }
}

