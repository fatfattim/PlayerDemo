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

class StartOverPlayerVCNew: PlayerViewController {
    var timer = Timer()

    private var poc_url_1 : URL = URL(string: "http://linear.demo.kkstream.tv/poc.m3u8")!
    private var poc_url_2 : URL = URL(string: "http://linear.demo.kkstream.tv/poc2.m3u8")!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)   {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.setURL(url: poc_url_1, describe : "none")
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
//        if((notification.object! as! AVPlayerItem) == player.currentItem) {
//            fileUrl = poc_url_1
//            asset = AVURLAsset(url: fileUrl, options: nil)
//        }
    }
    
    override func readyToPlay() {
        
        let seekTime = getInitTime()
        let newTime = CMTimeMakeWithSeconds(Float64(seekTime), 1)
        player.seek(to: newTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        player.play()
    }
    
    override func isControllerHidden(isHidden: Bool) {
        timeSlider.isHidden = isHidden
        startTimeLabel.isHidden = isHidden
        playPauseButton.isHidden = isHidden
        durationLabel.isHidden = isHidden
    }

    override func skipSetSliderValue() -> Bool {
        return true
    }
    
    func getInitTime() -> Int {
        let date = Date()
        let calendar = Calendar.current
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        let intervalTime = 60 * 10
        let currentTime = minutes * 60 + seconds
        return (currentTime % intervalTime)
    }
    
    func timerAction() {
        let seekTime = getInitTime()
        if(seekTime == 0) {
            
            if(fileUrl == poc_url_1) {
                fileUrl = poc_url_2
            } else {
                fileUrl = poc_url_1
            }
            
            asset = AVURLAsset(url: fileUrl, options: nil)
        } else {
            timeSlider.maximumValue = Float(seekTime)
            durationLabel.text = createTimeString(time: Float(seekTime))
        }
    }
}
