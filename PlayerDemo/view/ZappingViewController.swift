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
        loadScrollViewWithPage(page: 0)
    }
    
    private func viewDidLoadForPager() {
        
        // view controllers are created lazily
        // in the meantime, load the array with placeholders which will be replaced on demand
        let controllers: NSMutableArray = [];
        for _ in 1...COUNT_PAGE {
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

    private func loadScrollViewWithPage(page : Int) {
        if (page >= COUNT_PAGE) {
            return;
        }
        
        // replace the placeholder if necessary
        let controller : PlayerViewController
        if viewControllers[page] is String {
            controller = PlayerViewController()
            controller.setURL()
            viewControllers.replaceObject(at: page, with: controller)
        } else {
            controller = viewControllers[page] as! PlayerViewController
        }
        
        // add the controller's view to the scroll view
        if (controller.view.superview == nil)
        {
            var frame = self.scrollView.frame;
            
            let videoViewWidth = frame.size.width;
            frame.origin.x = (videoViewWidth) * CGFloat(page);
            frame.origin.y = -self.scrollView.frame.origin.y;
            frame.size.width = videoViewWidth;
            frame.size.height = frame.size.height;
            //frame.size.height = frame.size.height * 0.8;
            controller.view.frame = frame;
            addChildViewController(controller)
            scrollView.addSubview(controller.view)
            controller.didMove(toParentViewController: self)
            
        }
        
        if(page % 2 == 1) { //testing codes
            controller.view.backgroundColor = UIColor.red
        } else {
            controller.view.backgroundColor = UIColor.blue
        }
    }
}
