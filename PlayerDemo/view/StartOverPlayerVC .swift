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
    var timer = Timer()

    private var advertiseUrl : URL = URL(string: "https://s3-ap-northeast-1.amazonaws.com/videopass-testing-theater/99/999999_2597480b41a359c60799ec56534e408a/1494560333_hls_fps/480p_796k.m3u8")!

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)   {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.setURL(url: advertiseUrl, describe : "none")
        print("init nibName style")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playPauseButton.isHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer.invalidate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        
    }
    
    
    func timerAction() {
        let date = Date()
        let calendar = Calendar.current
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        print("seconds " , seconds)
        
        //let intervalTime = 60 * 15
        let intervalTime = 2 * 15
        let currentTime = minutes * 60 + seconds
        if((currentTime % intervalTime) == 0) {
            
            let url : URL = URL(string: "http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8")!
            
            asset = AVURLAsset(url: url, options: nil)
        }
    }
}
