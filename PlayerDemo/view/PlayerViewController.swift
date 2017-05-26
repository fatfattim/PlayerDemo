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


/*
	KVO context used to differentiate KVO callbacks for this class versus other
	classes in its class hierarchy.
 */
private var playerViewControllerKVOContext = 0
// Item Url : 
// http://linear.demo.kkstream.tv/ch1.m3u8
// http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8
class PlayerViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var seekInfoLabel: UILabel!
    // MARK: - IBOutlets
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var rewindButton: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var fastForwardButton: UIButton!
    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var debugLabel: UILabel!
    
    var _currentTime : CMTime!
    let player = AVPlayer()
    var debugText = ""
    var fileUrl : URL = Bundle.main.url(forResource: "ElephantSeals", withExtension: "mov")!
    // UINavigationControllerDelegate method
    public func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.landscapeLeft , UIInterfaceOrientationMask.landscapeRight]
    }

    public func setURL(url : URL, describe : String) {
        fileUrl = url
        debugText = describe
    }
    
    private func setOrientation() {
        self.navigationController?.delegate = self
        if (UIApplication.shared.statusBarOrientation.isPortrait) {
            let value = UIInterfaceOrientation.landscapeLeft.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        }
    }
    
    // Mark https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Properties.html
    // Properties practice
    private var _isShow : Bool = false
    var isShow: Bool {
        get {
            return _isShow
        }
        set(bool) {
            _isShow = bool
            
            if(_isShow) {
                player.isMuted = false
            } else {
                player.isMuted = true
            }
        }
    }
    
    private func hideButton() {
        timeSlider.isHidden = true
        startTimeLabel.isHidden = true
        durationLabel.isHidden = true
        rewindButton.isHidden = true
        playPauseButton.isHidden = true
        fastForwardButton.isHidden = true
    }

    private func setPanGesture() {
        let pan = UIPanGestureRecognizer(
            target:self,
            action:#selector(self.pan))
        pan.minimumNumberOfTouches = 1
        pan.maximumNumberOfTouches = 1
        //view.addGestureRecognizer(pan)
        seekInfoLabel.isUserInteractionEnabled = true
        seekInfoLabel.addGestureRecognizer(pan)
    }
    
    func pan(recognizer:UIPanGestureRecognizer) {
        let traslation = recognizer.translation(in: self.view)
        
        switch recognizer.state {
            case UIGestureRecognizerState.began:
                seekInfoLabel.textColor = UIColor.red
                _currentTime = self.player.currentTime()
            case UIGestureRecognizerState.changed:
                let time = reviseTime(CMTimeGetSeconds(_currentTime) + Float64(traslation.x / 10))
                
                self.seekInfoLabel.text = self.createTimeString(time: Float(time))
            case UIGestureRecognizerState.ended:
                seekInfoLabel.textColor = UIColor.clear
                currentTime = CMTimeGetSeconds(_currentTime) + Float64(traslation.x / 10)
            default: break
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setOrientation()
        setPanGesture()
        hideButton()
        
        debugLabel.text = debugText
    }
    
    private func shouldAutorotate() -> Bool {
        return true
    }
    
    // Player 
    // MARK: Properties
    
    // Attempt load and test these asset keys before playing.
    static let assetKeysRequiredToPlay = [
        "playable",
        "hasProtectedContent"
    ]
    
    var currentTime: Double {
        get {
            return CMTimeGetSeconds(player.currentTime())
        }
        set {
            let newTime = CMTimeMakeWithSeconds(reviseTime(newValue), 1)
            player.seek(to: newTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        }
    }
    
    private func reviseTime(_ newValue :Double) -> Float64 {
        if(newValue < 0) {
            return 0
        } else if (newValue >= CMTimeGetSeconds((self.player.currentItem?.duration)!)) {
            return CMTimeGetSeconds((self.player.currentItem?.duration)!)
        } else {
            return newValue
        }
    }
    
    var duration: Double {
        guard let currentItem = player.currentItem else { return 0.0 }
        
        return CMTimeGetSeconds(currentItem.duration)
    }
    
    var rate: Float {
        get {
            return player.rate
        }
        
        set {
            player.rate = newValue
        }
    }
    
    var asset: AVURLAsset? {
        didSet {
            guard let newAsset = asset else { return }
            
            asynchronouslyLoadURLAsset(newAsset)
        }
    }
    
    private var playerLayer: AVPlayerLayer? {
        return playerView.playerLayer
    }
    
    /*
     A formatter for individual date components used to provide an appropriate
     value for the `startTimeLabel` and `durationLabel`.
     */
    let timeRemainingFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        
        return formatter
    }()
    
    /*
     A token obtained from calling `player`'s `addPeriodicTimeObserverForInterval(_:queue:usingBlock:)`
     method.
     */
    private var timeObserverToken: Any?
    
    private var playerItem: AVPlayerItem? = nil {
        didSet {
            /*
             If needed, configure player item here before associating it with a player.
             (example: adding outputs, setting text style rules, selecting media options)
             */
            player.replaceCurrentItem(with: self.playerItem)
        }
    }
    
    // MARK: - View Controller
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /*
         Update the UI when these player properties change.
         
         Use the context parameter to distinguish KVO for our particular observers
         and not those destined for a subclass that also happens to be observing
         these properties.
         */
        addObserver(self, forKeyPath: #keyPath(PlayerViewController.player.currentItem.duration), options: [.new, .initial], context: &playerViewControllerKVOContext)
        addObserver(self, forKeyPath: #keyPath(PlayerViewController.player.rate), options: [.new, .initial], context: &playerViewControllerKVOContext)
        addObserver(self, forKeyPath: #keyPath(PlayerViewController.player.currentItem.status), options: [.new, .initial], context: &playerViewControllerKVOContext)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.moviePlayBackFinished),
            name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
            object: player.currentItem)
        
        playerView.playerLayer.player = player
        
        asset = AVURLAsset(url: fileUrl, options: nil)
        
        // Make sure we don't have a strong reference cycle by only capturing self as weak.
        let interval = CMTimeMake(1, 1)
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [unowned self] time in
            let timeElapsed = Float(CMTimeGetSeconds(time))
            
            self.timeSlider.value = Float(timeElapsed)
            self.startTimeLabel.text = self.createTimeString(time: timeElapsed)
        }
    }
    
    
    
    
    // Auto replay
    func moviePlayBackFinished(notification: Notification) {
       if((notification.object! as! AVPlayerItem) == player.currentItem) {
            let newTime = CMTimeMakeWithSeconds(0, 1)
            player.seek(to: newTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
            player.play()
        }
    }
    
    
    func getBufferTime1() {
        
        var loadedTimeRanges = self.player.currentItem?.loadedTimeRanges
        
        if(loadedTimeRanges != nil && !(loadedTimeRanges?.isEmpty)!) {
            let timeRange = loadedTimeRanges?[0].timeRangeValue
            let startSeconds = CMTimeGetSeconds((timeRange?.start)!)
            let durationSeconds = CMTimeGetSeconds((timeRange?.duration)!)
            let result = startSeconds + durationSeconds
            print(result)
        }
    }
    
    func getBufferTime() {
        let time : CMTime
        
        if let range = self.player.currentItem?.loadedTimeRanges.first {
            time = CMTimeRangeGetEnd(range.timeRangeValue)
        } else {
            time = kCMTimeZero
        }
        
        print(CMTimeShow(time))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let timeObserverToken = timeObserverToken {
            player.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
        
        player.pause()
        
        removeObserver(self, forKeyPath: #keyPath(PlayerViewController.player.currentItem.duration), context: &playerViewControllerKVOContext)
        removeObserver(self, forKeyPath: #keyPath(PlayerViewController.player.rate), context: &playerViewControllerKVOContext)
        removeObserver(self, forKeyPath: #keyPath(PlayerViewController.player.currentItem.status), context: &playerViewControllerKVOContext)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Asset Loading
    
    func asynchronouslyLoadURLAsset(_ newAsset: AVURLAsset) {
        /*
         Using AVAsset now runs the risk of blocking the current thread (the
         main UI thread) whilst I/O happens to populate the properties. It's
         prudent to defer our work until the properties we need have been loaded.
         */
        newAsset.loadValuesAsynchronously(forKeys: PlayerViewController.assetKeysRequiredToPlay) {
            /*
             The asset invokes its completion handler on an arbitrary queue.
             To avoid multiple threads using our internal state at the same time
             we'll elect to use the main thread at all times, let's dispatch
             our handler to the main queue.
             */
            DispatchQueue.main.async {
                /*
                 `self.asset` has already changed! No point continuing because
                 another `newAsset` will come along in a moment.
                 */
                guard newAsset == self.asset else { return }
                
                /*
                 Test whether the values of each of the keys we need have been
                 successfully loaded.
                 */
                for key in PlayerViewController.assetKeysRequiredToPlay {
                    var error: NSError?
                    
                    if newAsset.statusOfValue(forKey: key, error: &error) == .failed {
                        let stringFormat = NSLocalizedString("error.asset_key_%@_failed.description", comment: "Can't use this AVAsset because one of it's keys failed to load")
                        
                        let message = String.localizedStringWithFormat(stringFormat, key)
                        
                        self.handleErrorWithMessage(message, error: error)
                        
                        return
                    }
                }
                
                // We can't play this asset.
                if !newAsset.isPlayable || newAsset.hasProtectedContent {
                    let message = NSLocalizedString("error.asset_not_playable.description", comment: "Can't use this AVAsset because it isn't playable or has protected content")
                    
                    self.handleErrorWithMessage(message)
                    
                    return
                }
                
                /*
                 We can play this asset. Create a new `AVPlayerItem` and make
                 it our player's current item.
                 */
                self.playerItem = AVPlayerItem(asset: newAsset)
                
                /*self.playerItem?.addObserver(self, forKeyPath: "playbackBufferEmpty", options:[.new, .initial], context:&playerViewControllerKVOContext);
                self.playerItem?.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options:[.new, .initial], context:&playerViewControllerKVOContext);
                
                self.playerItem?.addObserver(self, forKeyPath: "loadedTimeRanges", options:[.new, .initial], context:&playerViewControllerKVOContext);*/
                
            }
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func playPauseButtonWasPressed(_ sender: UIButton) {
        if player.rate != 1.0 {
            // Not playing forward, so play.
            if currentTime == duration {
                // At end, so got back to begining.
                currentTime = 0.0
            }
            
            player.play()
        }
        else {
            // Playing, so pause.
            player.pause()
        }
    }
    
    @IBAction func rewindButtonWasPressed(_ sender: UIButton) {
            // Rewind no faster than -2.0.
        rate = max(player.rate - 2.0, -2.0)
    }
    
    @IBAction func fastForwardButtonWasPressed(_ sender: UIButton) {
        // Fast forward no faster than 2.0.
        rate = min(player.rate + 2.0, 2.0)
    }
    
    @IBAction func timeSliderDidChange(_ sender: UISlider) {
        currentTime = Double(sender.value)
    }
    
    // MARK: - KVO Observation
    
    // Update our UI when player or `player.currentItem` changes.
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        
        
        // Make sure the this KVO callback was intended for this view controller.
        guard context == &playerViewControllerKVOContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        if keyPath == #keyPath(PlayerViewController.player.currentItem.duration) {
            // Update timeSlider and enable/disable controls when duration > 0.0
            
            /*
             Handle `NSNull` value for `NSKeyValueChangeNewKey`, i.e. when
             `player.currentItem` is nil.
             */
            let newDuration: CMTime
            if let newDurationAsValue = change?[NSKeyValueChangeKey.newKey] as? NSValue {
                newDuration = newDurationAsValue.timeValue
            }
            else {
                newDuration = kCMTimeZero
            }
            
            //let hasValidDuration = newDuration.isNumeric && newDuration.value != 0
            var hasValidDuration = newDuration.isNumeric && newDuration.value != 0
            let newDurationSeconds = hasValidDuration ? CMTimeGetSeconds(newDuration) : 0.0
            let currentTime = hasValidDuration ? Float(CMTimeGetSeconds(player.currentTime())) : 0.0
            
            timeSlider.maximumValue = Float(newDurationSeconds)
            
            timeSlider.value = currentTime
            
            hasValidDuration = true
            
            rewindButton.isEnabled = hasValidDuration
            
            playPauseButton.isEnabled = hasValidDuration
            
            fastForwardButton.isEnabled = hasValidDuration
            
            timeSlider.isEnabled = hasValidDuration
            
            startTimeLabel.isEnabled = hasValidDuration
            startTimeLabel.text = createTimeString(time: currentTime)
            
            durationLabel.isEnabled = hasValidDuration
            durationLabel.text = createTimeString(time: Float(newDurationSeconds))
        }
        else if keyPath == #keyPath(PlayerViewController.player.rate) {
            // Update `playPauseButton` image.
            
            let newRate = (change?[NSKeyValueChangeKey.newKey] as! NSNumber).doubleValue
            
            let buttonImageName = newRate == 1.0 ? "PauseButton" : "PlayButton"
            
            let buttonImage = UIImage(named: buttonImageName)
            
            playPauseButton.setImage(buttonImage, for: UIControlState())
        }
        else if keyPath == #keyPath(PlayerViewController.player.currentItem.status) {
            // Display an error if status becomes `.Failed`.
            
            /*
             Handle `NSNull` value for `NSKeyValueChangeNewKey`, i.e. when
             `player.currentItem` is nil.
             */
            let newStatus: AVPlayerItemStatus
            
            if let newStatusAsNumber = change?[NSKeyValueChangeKey.newKey] as? NSNumber {
                newStatus = AVPlayerItemStatus(rawValue: newStatusAsNumber.intValue)!
            }
            else {
                newStatus = .unknown
            }
            
            if newStatus == .failed {
                handleErrorWithMessage(player.currentItem?.error?.localizedDescription, error:player.currentItem?.error)
            }
            
            if (newStatus == .readyToPlay) {
                readyToPlay()
            }

        } else if (object as? AVPlayerItem == playerItem && keyPath == "loadedTimeRanges") {
            let time : CMTime

            if let range = self.player.currentItem?.loadedTimeRanges.first {
                time = CMTimeRangeGetEnd(range.timeRangeValue)
            } else {
                time = kCMTimeZero
            }
            
            //print(CMTimeShow(time))
        }
    }
    
    
    func readyToPlay() {
        player.play()
    }
    
    // Trigger KVO for anyone observing our properties affected by player and player.currentItem
    override class func keyPathsForValuesAffectingValue(forKey key: String) -> Set<String> {
        let affectedKeyPathsMappingByKey: [String: Set<String>] = [
            "duration":     [#keyPath(PlayerViewController.player.currentItem.duration)],
            "rate":         [#keyPath(PlayerViewController.player.rate)]
        ]
        
        return affectedKeyPathsMappingByKey[key] ?? super.keyPathsForValuesAffectingValue(forKey: key)
    }
    
    // MARK: - Error Handling
    
    func handleErrorWithMessage(_ message: String?, error: Error? = nil) {
        NSLog("Error occured with message: \(String(describing: message)), error: \(String(describing: error)).")
        
        let alertTitle = NSLocalizedString("alert.error.title", comment: "Alert title for errors")
        let defaultAlertMessage = NSLocalizedString("error.default.description", comment: "Default error message when no NSError provided")
        
        let alert = UIAlertController(title: alertTitle, message: message == nil ? defaultAlertMessage : message, preferredStyle: UIAlertControllerStyle.alert)
        
        let alertActionTitle = NSLocalizedString("alert.error.actions.OK", comment: "OK on error alert")
        
        let alertAction = UIAlertAction(title: alertActionTitle, style: .default, handler: nil)
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: Convenience
    
    func createTimeString(time: Float) -> String {
        let components = NSDateComponents()
        components.second = Int(max(0.0, time))
        
        return timeRemainingFormatter.string(from: components as DateComponents)!
    }

}
