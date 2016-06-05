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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let url = NSURL(string:
        //    "http://jplayer.org/video/m4v/Big_Buck_Bunny_Trailer.m4v")

    }
    
    @IBAction func play_online_video(sender: AnyObject) {
        let videoURL = NSURL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        self.player = AVPlayer(URL: videoURL!)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        self.view.layer.addSublayer(playerLayer)
        player.closedCaptionDisplayEnabled = true
        player.play()
        create_video_controls()
    }
    
    func create_video_controls() {
        let button = UIButton(frame: CGRect(x: 100, y: 500, width: 75, height: 35))
        button.backgroundColor = .blueColor()
        button.layer.cornerRadius = 5
        button.setTitle("Pause", forState: .Normal)
        button.addTarget(self, action: #selector(pauseButtonAction), forControlEvents: .TouchUpInside)
        self.view.addSubview(button)
        
        let resume_button = UIButton(frame: CGRect(x: 200, y: 500, width: 75, height: 35))
        resume_button.backgroundColor = .blueColor()
        resume_button.layer.cornerRadius = 5
        resume_button.setTitle("Play", forState: .Normal)
        resume_button.addTarget(self, action: #selector(resumeButtonAction), forControlEvents: .TouchUpInside)
        self.view.addSubview(resume_button)

    }
    
    func pauseButtonAction(sender: UIButton!) {
        print("Video Paused")
        self.player.pause()
    }
    
    func resumeButtonAction(sender: UIButton!) {
        print("Video resumed")
        self.player.play()
    }
    
}





