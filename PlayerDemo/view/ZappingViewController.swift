//
//  ZappingViewController.swift
//  PlayerDemo
//
//  Created by TimChen on 2017/5/22.
//  Copyright © 2017年 dogtim. All rights reserved.
//

import UIKit

class ZappingViewController: UIViewController , UINavigationControllerDelegate {

    // MARK: - UINavigationControllerDelegate method
    public func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.landscapeLeft , UIInterfaceOrientationMask.landscapeRight]
    }
    
    private func setOrientation() {
        self.navigationController?.delegate = self
        if (UIApplication.shared.statusBarOrientation.isPortrait) {
            let value = UIInterfaceOrientation.landscapeRight.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setOrientation()
    }
    
    private func shouldAutorotate() -> Bool {
        return true
    }
}
