//
//  PlayerViewController.swift
//  PlayerDemo
//
//  Created by TimChen on 2017/5/19.
//  Copyright © 2017年 dogtim. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController, UINavigationControllerDelegate {
    

    // UINavigationControllerDelegate method
    public func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.landscapeLeft , UIInterfaceOrientationMask.landscapeRight]
    }

    private func setOrientation() {
        self.navigationController?.delegate = self
        if (UIApplication.shared.statusBarOrientation.isPortrait) {
            let value = UIInterfaceOrientation.landscapeLeft.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setOrientation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func shouldAutorotate() -> Bool {
        return true
    }

}
