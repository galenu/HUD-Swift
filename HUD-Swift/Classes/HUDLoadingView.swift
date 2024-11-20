//
//  HUDLoadingView.swift
//  JCXX
//
//  Created by gavin on 2023/7/20.
//

import UIKit
import SnapKit

/// 默认Loading
public class HUDLoadingView: UIView {
    
    /// loading动画
    public lazy var imageView: UIImageView = {
        let view =  UIImageView()
        return view
    }()
    
    /// 提示label
    public lazy var textLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14)
        view.textColor = .white
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()
    
    public init(text: String = "",
                imageSize: CGSize = CGSize(width: 54, height: 54),
                maxWidth: CGFloat = UIScreen.main.bounds.width - 100) {
                
        super.init(frame: CGRect.zero)
        
        self.backgroundColor = .black
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        
        self.addSubview(imageView)
        
        if !text.isEmpty {
            
            imageView.snp.remakeConstraints { (make) in
                make.top.equalToSuperview().offset(10)
                make.centerX.equalToSuperview()
                make.size.equalTo(imageSize)
            }
            
            let font = textLabel.font ?? .systemFont(ofSize: 14)
            let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
            let textSize = text.boundingRect(with: size,
                                             options: .usesLineFragmentOrigin,
                                             attributes: [NSAttributedString.Key.font: font],
                                             context: nil).size
            
            // 文字宽度
            let textWidth = textSize.width + 40
            // 最小宽度
            let minWidth = CGFloat.minimum(textWidth, maxWidth)
            let width = CGFloat.maximum(minWidth, imageSize.width + 20)
            
            textLabel.text = text
            self.addSubview(textLabel)
            textLabel.snp.remakeConstraints { (make) in
                make.top.equalTo(imageView.snp.bottom).offset(5)
                make.centerX.equalToSuperview()
                make.leading.equalToSuperview().offset(10)
                make.width.equalTo(width)
                
                make.bottom.equalToSuperview().offset(-20)
            }
        } else {
            imageView.snp.remakeConstraints { (make) in
                make.top.equalToSuperview().offset(10)
                make.centerX.equalToSuperview()
                make.leading.equalToSuperview().offset(10)
                make.size.equalTo(imageSize)
                
                make.bottom.equalToSuperview().offset(-10)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        // view被移除时
        if newSuperview == nil {
            self.stopRotateAnimation()
        } else {
            self.startRotateAnimation()
        }
    }
    
    /// 开始旋转动画
    private func startRotateAnimation(duration: CGFloat = 0.5) {
        self.stopRotateAnimation()
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.toValue = Double.pi * 2.0
        animation.duration = duration
        animation.repeatCount = Float.greatestFiniteMagnitude
        animation.isRemovedOnCompletion = false
        imageView.layer.add(animation, forKey: "RotateAnimation")
    }
    
    /// 结束旋转动画
    private func stopRotateAnimation() {
        imageView.layer.removeAnimation(forKey: "RotateAnimation")
    }
}
