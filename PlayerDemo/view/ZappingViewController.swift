//
//  ZappingViewController.swift
//  PlayerDemo
//
//  Created by TimChen on 2017/5/22.
//  Copyright © 2017年 dogtim. All rights reserved.
//

import UIKit

class ZappingViewController: UIViewController , UINavigationControllerDelegate , UIScrollViewDelegate {
    let COUNT_PAGE = 6
    var viewControllers: NSMutableArray = []

    @IBOutlet weak var scrollView: UIScrollView!
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
    
    override func viewDidAppear(_ animated : Bool) {
        super.viewDidAppear(animated)
        viewDidLoadForPager()
    }
    
    private func viewDidLoadForPager() {
        
        // view controllers are created lazily
        // in the meantime, load the array with placeholders which will be replaced on demand
        let controllers: NSMutableArray = [];
        for index in 1...COUNT_PAGE {
            print("\(index) times 5 is \(index * 5)")
            controllers.add("")
        }
        self.viewControllers = controllers;
        
        scrollView.isPagingEnabled = true
        
        //http://ztpala.com/2011/06/22/customize-page-size-uiscrollview/
        scrollView.clipsToBounds = false
        scrollView.bounces = false

        let width = scrollView.frame.width * CGFloat(COUNT_PAGE)
        scrollView.contentSize = CGSize(width: width, height: self.scrollView.frame.height);
        scrollView.showsHorizontalScrollIndicator = false;
        scrollView.showsVerticalScrollIndicator = false;
        scrollView.scrollsToTop = false;
        scrollView.delegate = self;
    }
}
