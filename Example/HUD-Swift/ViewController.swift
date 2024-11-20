//
//  ViewController.swift
//  HUD-Swift
//
//  Created by galenu on 11/20/2024.
//  Copyright (c) 2024 galenu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func loadingClick(_ sender: Any) {
        self.view.showLoading()
        
    }
    
    @IBAction func skeletonLoadingClick(_ sender: Any) {
        self.view.showSkeletonLoading(image: UIImage(named: "loading/buy"))
    }
    
    @IBAction func toastClick(_ sender: Any) {
        self.view.showToast("输入格式不正确...")
    }
}

