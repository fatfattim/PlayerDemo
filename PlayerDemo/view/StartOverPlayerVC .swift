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
    private var programUrl : URL = URL(string: "https://s3-ap-northeast-1.amazonaws.com/kkstream-testing-tmp/theater/hls_demo/ch1/KYFKD_tid_0000596788/KYFKD_tid_0000596788.m3u8")!
    
    
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
        timeSlider.isHidden = false
        startTimeLabel.isHidden = false
        playPauseButton.isHidden = false
        durationLabel.isHidden = false
        seekInfoLabel.isHidden = true
        debugLabel.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer.invalidate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    // Play advertisement if the program finish
    override func moviePlayBackFinished(notification: Notification) {
        if((notification.object! as! AVPlayerItem) == player.currentItem) {
            fileUrl = advertiseUrl
            asset = AVURLAsset(url: fileUrl, options: nil)
        }
    }
    
    func timerAction() {
        let date = Date()
        let calendar = Calendar.current
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        let intervalTime = 60 * 15
        
        let currentTime = minutes * 60 + seconds
        if((currentTime % intervalTime) == 0) {
            fileUrl = programUrl
            asset = AVURLAsset(url: fileUrl, options: nil)
        }
    }
}
