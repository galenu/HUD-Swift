//
//  HUDToastView.swift
//  JCXX
//
//  Created by gavin on 2023/7/20.
//

import UIKit
import SnapKit

/// toast view
public class HUDToastView: UIView {
    
    /// 容器
    public lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = 16
        return view
    }()
    
    public lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    /// 提示label
    public lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    public init(text: String,
                image: UIImage? = nil) {
        
        super.init(frame: CGRect.zero)
        
        self.setupUI()
        
        textLabel.text = text
        imageView.image = image
        imageView.isHidden = image == nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
        
        self.backgroundColor = .black
        
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.width.lessThanOrEqualTo(UIScreen.main.bounds.width - 32)
        }
        
        stackView.addArrangedSubview(imageView)
        
        stackView.addArrangedSubview(textLabel)
    }
}
