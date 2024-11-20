//
//  HUDSkeletonLoadingView.swift
//  JCXX
//
//  Created by gavin on 2023/9/14.
//

import UIKit

/// 骨架屏加载
public class HUDSkeletonLoadingView: UIView {

    /// 占位图片
    public lazy var imageView = UIImageView()
    
    /// 内边距
    public var padding: UIEdgeInsets = .zero {
        didSet {
            imageView.snp.remakeConstraints { make in
                make.top.equalToSuperview().offset(padding.top)
                make.bottom.equalToSuperview().offset(-padding.bottom)
                make.leading.equalToSuperview().offset(padding.left)
                make.trailing.equalToSuperview().offset(-padding.right)
            }
        }
    }
        
    public init() {
        
        super.init(frame: CGRect.zero)
        
        imageView = UIImageView()
        self.addSubview(imageView)
        imageView.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(padding.top)
            make.bottom.equalToSuperview().offset(-padding.bottom)
            make.leading.equalToSuperview().offset(padding.left)
            make.trailing.equalToSuperview().offset(-padding.right)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
