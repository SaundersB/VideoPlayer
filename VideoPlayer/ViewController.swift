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
    
    @IBOutlet weak var play_button: UIButton!
    var player = AVPlayer()
    var playerLayer = AVPlayerLayer()
    let pause_button = UIButton(frame: CGRect(x: 100, y: 500, width: 75, height: 35))
    let resume_button = UIButton(frame: CGRect(x: 200, y: 500, width: 75, height: 35))
    let destroy_video_player_button = UIButton(frame: CGRect(x: 300, y: 500, width: 75, height: 35))

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let url = NSURL(string:
        //    "http://jplayer.org/video/m4v/Big_Buck_Bunny_Trailer.m4v")

    }
    
    @IBAction func play_online_video(sender: AnyObject) {
        let videoURL = NSURL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        self.player = AVPlayer(URL: videoURL!)
        self.playerLayer = AVPlayerLayer(player: player)
        self.playerLayer.frame = self.view.bounds
        self.view.layer.addSublayer(playerLayer)
        self.player.play()
        create_video_controls()
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
        dispatch_async(dispatch_get_main_queue()) {
            self.player.pause()
            self.playerLayer.removeFromSuperlayer()
        }
        pause_button.hidden = true
        resume_button.hidden = true
        destroy_video_player_button.hidden = true
        
    }
    
}





