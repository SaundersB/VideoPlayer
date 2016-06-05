//
//  VideoPlayer.swift
//  VideoPlayer
//
//  Created by Brandon_Saunders on 6/4/16.
//  Copyright © 2016 Brandon Saunders. All rights reserved.
//
import UIKit
import AVKit
import AVFoundation

class VideoPlayer: UIViewController {
    
    @IBOutlet weak var video_player_header: UILabel!
    @IBOutlet weak var stack_view: UIStackView!
    @IBOutlet weak var play_button: UIButton!
    
    @IBOutlet weak var file_list: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        video_player_header.font = UIFont (name: "Helvetica Neue", size: 30)
        video_player_header.textAlignment = NSTextAlignment.Center;
        play_button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        getFiles()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func playVideo() throws {
        guard let path = NSBundle.mainBundle().pathForResource("video", ofType:"m4v") else {
            throw AppError.InvalidResource("video", "m4v")
        }
        let player = AVPlayer(URL: NSURL(fileURLWithPath: path))
        let playerController = AVPlayerViewController()
        playerController.player = player
        self.presentViewController(playerController, animated: true) {
            player.play()
        }
    }
    
    @IBAction func play_video(sender: AnyObject) {
        do {
            try playVideo()
        } catch AppError.InvalidResource(let name, let type) {
            debugPrint("Could not find resource \(name).\(type)")
        } catch {
            debugPrint("Generic error")
        }
    }
    
    
    func getFiles() {
        let filemanager:NSFileManager = NSFileManager()
        let files = filemanager.enumeratorAtPath(NSHomeDirectory())
        var listOfFiles: [String] = []
        while let file = files?.nextObject() {
            print(file)
            listOfFiles.append(file as! String)
        }
        
        file_list.text = "Local Files: " + String(listOfFiles)
        file_list.textAlignment = NSTextAlignment.Center
        file_list.numberOfLines = 10
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        var orientation = UIInterfaceOrientationMask()
        orientation = [UIInterfaceOrientationMask.Portrait, UIInterfaceOrientationMask.PortraitUpsideDown]
        return orientation
    }
    
}

enum AppError : ErrorType {
    case InvalidResource(String, String)
}

