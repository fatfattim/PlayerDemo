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
        self.setURL(url: programUrl, describe : "none")
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
    
    override func readyToPlay() {
        if(fileUrl != advertiseUrl) {
            let seekTime = getInitTime()
            
            if (Double(seekTime) >= (player.currentItem?.duration.seconds)!) {
                fileUrl = advertiseUrl
                asset = AVURLAsset(url: fileUrl, options: nil)
            } else {
                let newTime = CMTimeMakeWithSeconds(Float64(seekTime), 1)
                player.seek(to: newTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
                player.play()
            }
        } else {
            super.readyToPlay()
        }
    }
    
    func getInitTime() -> Int {
        let date = Date()
        let calendar = Calendar.current
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        print("seconds ", seconds)
        let intervalTime = 60 * 15
        
        let currentTime = minutes * 60 + seconds
        
        return (currentTime % intervalTime)
    }
    
    func timerAction() {
        let seekTime = getInitTime()
        if(seekTime == 0) {
            fileUrl = programUrl
            asset = AVURLAsset(url: fileUrl, options: nil)
        } else {
            timeSlider.maximumValue = Float(seekTime)
            durationLabel.text = createTimeString(time: Float(seekTime))
        }
    }
}
