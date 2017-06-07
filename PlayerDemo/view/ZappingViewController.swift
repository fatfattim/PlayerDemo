//
//  ZappingViewController.swift
//  PlayerDemo
//
//  Created by TimChen on 2017/5/22.
//  Copyright © 2017年 dogtim. All rights reserved.
//

import UIKit

// Item Url : http://linear.demo.kkstream.tv/ch1.m3u8

class ZappingViewController: UIViewController , UINavigationControllerDelegate , UIScrollViewDelegate {
    let COUNT_PAGE = 6

    var callback:((Int)->PlayerViewController)?
    
    var viewControllers: NSMutableArray = []
    var currentPage = 0
    var barIsHidden = false

    @IBOutlet weak var customNavi: UINavigationBar!
    @IBOutlet weak var scrollView: UIScrollView!
    // MARK: - UINavigationControllerDelegate method
    public func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.landscapeLeft , UIInterfaceOrientationMask.landscapeRight]
    }
    
    // MARK: - UIScrollViewDelegate method
    // At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // switch the indicator when more than 50% of the previous/next page is visible
        let pageWidth = scrollView.frame.width
        currentPage = Int(floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + CGFloat(1))
        
        // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
        
        loadScrollViewWithPage(currentPage - 1)
        loadScrollViewWithPage(currentPage)
        loadScrollViewWithPage(currentPage + 1)
    
        // a possible optimization would be to unload the views+controllers which are no longer visible
    }
    
    public func setCallback(callback:@escaping (Int)->PlayerViewController) {
        self.callback = callback
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
        setNavigation()
        setToggleEvent()
    }
    
    private func setToggleEvent() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.toggle(_:)))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(gesture)
    }
    
    func toggle(_ sender: UITapGestureRecognizer) {
        setHiddenTask(isHidden: !barIsHidden)
    }
    
    private func setHiddenTask(isHidden: Bool) {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            self.customNavi.isHidden = true
            
            for viewController in self.viewControllers {
                if((viewController as? String) != nil) {
                    continue
                }
                
                (viewController as! PlayerViewController).isControllerHidden(isHidden: isHidden)
            }
            self.barIsHidden = isHidden
            self.customNavi.isHidden = isHidden
        }, completion: nil)
    }
    
    private func setNavigation() {
        self.navigationController?.navigationBar.isHidden = true
        // Create a navigation item with a title
        let navigationItem = UINavigationItem()
        navigationItem.title = "ZappingHa" //If you want to set a tilte set here.Whatever you want set here.
        
        // Create  button for navigation item with refresh
        let refreshButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action:#selector(self.actionBack))

        // I set refreshButton for the navigation item
        navigationItem.leftBarButtonItem = refreshButton
        
        customNavi.setItems([navigationItem], animated: false)
    }
    
    func actionBack(sender: UIBarButtonItem)
    {
        self.navigationController?.navigationBar.isHidden = false
         self.navigationController?.popViewController(animated: true)
    }

    private func shouldAutorotate() -> Bool {
        return true
    }
    
    override func viewDidAppear(_ animated : Bool) {
        super.viewDidAppear(animated)
        viewDidLoadForPager()
        loadScrollViewWithPage(0)
    }
    
    private func viewDidLoadForPager() {
        
        // view controllers are created lazily
        // in the meantime, load the array with placeholders which will be replaced on demand
        let controllers: NSMutableArray = []
        for _ in 1...COUNT_PAGE {
            controllers.add("")
        }
        self.viewControllers = controllers
        
        scrollView.isPagingEnabled = true
        
        //http://ztpala.com/2011/06/22/customize-page-size-uiscrollview/
        scrollView.clipsToBounds = false
        scrollView.bounces = false

        let width = scrollView.frame.width * CGFloat(COUNT_PAGE - 1)
        // height is magic number which match offset y, I do not know why....
        scrollView.contentSize = CGSize(width: width,
                                        height: (self.scrollView.frame.height - self.scrollView.frame.origin.y))
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.delegate = self
    }

    private func loadScrollViewWithPage(_ page : Int) {
        if (page >= COUNT_PAGE - 1 || page < 0) {
            return
        }
        
        // replace the placeholder if necessary
        let controller : PlayerViewController
        if viewControllers[page] is String {
            controller = self.callback!(page)
            viewControllers.replaceObject(at: page, with: controller)
        } else {
            controller = viewControllers[page] as! PlayerViewController
        }
        
        // add the controller's view to the scroll view
        if (controller.view.superview == nil) {
            var frame = self.scrollView.frame
            
            let videoViewWidth = frame.size.width
            frame.origin.x = (videoViewWidth) * CGFloat(page)
            frame.origin.y = -self.scrollView.frame.origin.y / 2
            frame.size.width = videoViewWidth
            frame.size.height = frame.size.height
            
            controller.view.frame = frame
            addChildViewController(controller)
            scrollView.addSubview(controller.view)
            controller.didMove(toParentViewController: self)
            
        }
        
        if(currentPage == page) {
            controller.isShow = true
        } else {
            controller.isShow = false
        }
    }
}
