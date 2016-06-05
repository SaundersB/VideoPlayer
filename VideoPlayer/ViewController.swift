//
//  ViewController.swift
//  VideoPlayer
//
//  Created by Brandon_Saunders on 6/4/16.
//  Copyright © 2016 Brandon Saunders. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import MediaPlayer
import AVKit

class ViewController: UIViewController {
    
    // Test Buttons
    @IBOutlet weak var play_button: UIButton!
    @IBOutlet weak var play_local_button: UIButton!
    var invisibleButton = UIButton()

    // Displays the time in the video.
    var timeObserver: AnyObject!
    var timeRemainingLabel: UILabel = UILabel()
    var seekSlider: UISlider = UISlider()
    var playerRateBeforeSeek: Float = 0
    var loadingIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    let playbackLikelyToKeepUpContext = UnsafeMutablePointer<(Void)>()
    
    // Video Player
    var player = AVPlayer()
    var playerLayer = AVPlayerLayer()
    let av_player_view_controller = AVPlayerViewController()

    // Screen Orientation
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    let height = UIScreen.mainScreen().bounds.size.height
    let width = UIScreen.mainScreen().bounds.size.width
    
    // Controller Buttons
    let pause_button = UIButton(frame: CGRect(x: 100, y: 500, width: 75, height: 35))
    let resume_button = UIButton(frame: CGRect(x: 200, y: 500, width: 75, height: 35))
    let destroy_video_player_button = UIButton(frame: CGRect(x: 300, y: 500, width: 75, height: 35))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let url = NSURL(string:
        //    "http://jplayer.org/video/m4v/Big_Buck_Bunny_Trailer.m4v")
        
    }
    
    @IBAction func play_online_video(sender: AnyObject) {
        play_button.hidden = true
        play_local_button.hidden = true
        
        let videoURL = NSURL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        view.backgroundColor = UIColor.blackColor()
        
        self.playerLayer = AVPlayerLayer(player: self.player)
        
        view.addSubview(timeRemainingLabel);
        view.layer.insertSublayer(self.playerLayer, atIndex: 0)
        
        
        view.addSubview(self.invisibleButton)
        self.invisibleButton.addTarget(self, action: #selector(ViewController.invisibleButtonTapped(_:)),
                                  forControlEvents: UIControlEvents.TouchUpInside)

        let playerItem = AVPlayerItem(URL: videoURL!)
        
        self.player.replaceCurrentItemWithPlayerItem(playerItem)
        
        let timeInterval: CMTime = CMTimeMakeWithSeconds(1.0, 10)
        timeObserver = self.player.addPeriodicTimeObserverForInterval(timeInterval, queue: dispatch_get_main_queue()) { (elapsedTime: CMTime) -> Void in
            //NSLog("elapsedTime now %f", CMTimeGetSeconds(elapsedTime));
            self.observeTime(elapsedTime)
        }
        
        timeRemainingLabel.textColor = UIColor.whiteColor()
        view.addSubview(timeRemainingLabel);

        view.addSubview(seekSlider)
        
        seekSlider.addTarget(self, action: #selector(ViewController.sliderBeganTracking(_:)),
                             forControlEvents: UIControlEvents.TouchDown)
        seekSlider.addTarget(self, action: #selector(ViewController.sliderEndedTracking(_:)),forControlEvents: UIControlEvents.TouchUpOutside)
        seekSlider.addTarget(self, action: #selector(ViewController.sliderEndedTracking(_:)),forControlEvents: UIControlEvents.TouchUpInside)
        seekSlider.addTarget(self, action: #selector(ViewController.sliderValueChanged(_:)),
                             forControlEvents: UIControlEvents.ValueChanged)
        
        loadingIndicatorView.hidesWhenStopped = true
        view.addSubview(loadingIndicatorView)
        self.player.addObserver(self, forKeyPath: "currentItem.playbackLikelyToKeepUp",
                             options: NSKeyValueObservingOptions.New, context: playbackLikelyToKeepUpContext)
        /*
        self.player = AVPlayer(URL: videoURL!)
        self.av_player_view_controller.player = self.player
        self.playerLayer = AVPlayerLayer(player: player)
        self.playerLayer.frame = self.view.bounds
        self.view.layer.addSublayer(playerLayer)
        self.player.play()
        */
        //create_video_controls()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.destroyVideoPlayer(_:)),
                                                         name: AVPlayerItemDidPlayToEndTimeNotification, object: self.player.currentItem)
        print(self.height, self.width, self.screenSize)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>)
    {
        
        if (context == playbackLikelyToKeepUpContext) {
            if (self.player.currentItem!.playbackLikelyToKeepUp) {
                loadingIndicatorView.stopAnimating()
            } else {
                loadingIndicatorView.startAnimating()
            }
        }
    }
    
    private func updateTimeLabel(elapsedTime: Float64, duration: Float64) {
        let timeRemaining: Float64 = CMTimeGetSeconds(self.player.currentItem!.duration) - elapsedTime
        timeRemainingLabel.text = String(format: "%02d:%02d", ((lround(timeRemaining) / 60) % 60), lround(timeRemaining) % 60)
    }
    
    private func observeTime(elapsedTime: CMTime) {
        let duration = CMTimeGetSeconds(self.player.currentItem!.duration);
        if (isfinite(duration)) {
            let elapsedTime = CMTimeGetSeconds(elapsedTime)
            updateTimeLabel(elapsedTime, duration: duration)
        }
    }
    
    deinit {
        self.player.removeTimeObserver(timeObserver)
        self.player.removeObserver(self, forKeyPath: "currentItem.playbackLikelyToKeepUp")

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadingIndicatorView.startAnimating()
        self.player.play() // Start the playback
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // Layout subviews manually
        self.playerLayer.frame = view.bounds;
        self.invisibleButton.frame = view.bounds;
        invisibleButton.frame = view.bounds;
        let controlsHeight: CGFloat = 30
        let controlsY: CGFloat = view.bounds.size.height - controlsHeight;
        timeRemainingLabel.frame = CGRect(x: 5, y: controlsY, width: 60, height: controlsHeight)
        seekSlider.frame = CGRect(x: timeRemainingLabel.frame.origin.x + timeRemainingLabel.bounds.size.width, y: controlsY, width: view.bounds.size.width - timeRemainingLabel.bounds.size.width - 5, height: controlsHeight)
        loadingIndicatorView.center = CGPoint(x: CGRectGetMidX(view.bounds), y: CGRectGetMidY(view.bounds))
    }
    
    func sliderBeganTracking(slider: UISlider!) {
        print("Slider began tracking")
        playerRateBeforeSeek = self.player.rate
        self.player.pause()
    }
    
    func sliderEndedTracking(slider: UISlider!) {
        print("Slider ended tracking")
        let videoDuration = CMTimeGetSeconds(self.player.currentItem!.duration)
        let elapsedTime: Float64 = videoDuration * Float64(seekSlider.value)
        updateTimeLabel(elapsedTime, duration: videoDuration)
        
        self.player.seekToTime(CMTimeMakeWithSeconds(elapsedTime, 10)) { (completed: Bool) -> Void in
            if (self.playerRateBeforeSeek > 0) {
                self.player.play()
            }
        }
    }
    
    func sliderValueChanged(slider: UISlider!) {
        print("Slider value has changed")
        let videoDuration = CMTimeGetSeconds(self.player.currentItem!.duration)
        let elapsedTime: Float64 = videoDuration * Float64(seekSlider.value)
        updateTimeLabel(elapsedTime, duration: videoDuration)
    }
    /*
    
    // Force the view into landscape mode (which is how most video media is consumed.)
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        var orientation = UIInterfaceOrientationMask()
        orientation = [UIInterfaceOrientationMask.Landscape, UIInterfaceOrientationMask.PortraitUpsideDown]
        return orientation
    }
 */
    
    func invisibleButtonTapped(sender: UIButton!) {
        let playerIsPlaying:Bool = self.player.rate > 0
        if (playerIsPlaying) {
            self.player.pause();
        } else {
            self.player.play();
        }
    }
    
    func create_video_controls() {
        pause_button.hidden = false
        pause_button.backgroundColor = .blueColor()
        pause_button.layer.cornerRadius = 5
        pause_button.setTitle("Pause", forState: .Normal)
        pause_button.addTarget(self, action: #selector(pauseButtonAction), forControlEvents: .TouchUpInside)
        self.view.addSubview(pause_button)
        
        resume_button.hidden = false
        resume_button.backgroundColor = .blueColor()
        resume_button.layer.cornerRadius = 5
        resume_button.setTitle("Play", forState: .Normal)
        resume_button.addTarget(self, action: #selector(resumeButtonAction), forControlEvents: .TouchUpInside)
        self.view.addSubview(resume_button)

        destroy_video_player_button.hidden = false
        destroy_video_player_button.backgroundColor = .blueColor()
        destroy_video_player_button.layer.cornerRadius = 5
        destroy_video_player_button.setTitle("Close", forState: .Normal)
        destroy_video_player_button.addTarget(self, action: #selector(destroyVideoPlayer), forControlEvents: .TouchUpInside)
        self.view.addSubview(destroy_video_player_button)
    }
    
    func pauseButtonAction(sender: UIButton!) {
        print("Video Paused")
        self.player.pause()
    }
    
    func resumeButtonAction(sender: UIButton!) {
        print("Video resumed")
        self.player.play()
    }
    
    func destroyVideoPlayer(sender: UIButton!) {
        play_button.hidden = false
        play_local_button.hidden = false
        view.backgroundColor = UIColor.whiteColor()

        dispatch_async(dispatch_get_main_queue()) {
            self.player.pause()
            self.playerLayer.removeFromSuperlayer()
        }
        pause_button.hidden = true
        resume_button.hidden = true
        destroy_video_player_button.hidden = true
        seekSlider.hidden = true
    }
    
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        getScreenSize()
    }
    var screenWidth:CGFloat=0
    var screenHeight:CGFloat=0
    
    func getScreenSize(){
        screenWidth=UIScreen.mainScreen().bounds.width
        screenHeight=UIScreen.mainScreen().bounds.height
        print("SCREEN RESOLUTION: " + screenWidth.description + " x " + screenHeight.description)
    }

}





