//
//  PlayerViewController.swift
//  PlayerDemo
//
//  Created by TimChen on 2017/5/19.
//  Copyright © 2017年 dogtim. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class StartOverPlayerVC: PlayerViewController {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)   {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.setURL(url: URL(string: "http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8")!, describe : "none")
        print("init nibName style")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playPauseButton.isHidden = false
    }
}
