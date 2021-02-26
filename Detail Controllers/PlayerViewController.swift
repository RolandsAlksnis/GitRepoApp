//
//  AVPlayerViewController.swift
//  Lumen
//
//  Created by rolands.alksnis on 08/08/2019.
//  Copyright © 2019 rolands.alksnis. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class PlayerViewController: AVPlayerViewController {
    
    
    var currentMedia: MediaContent?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let validName = currentMedia?.name {
            let mediaUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let filePathInLocalStorage = mediaUrl.appendingPathComponent(validName)
            let player = AVPlayer(url: filePathInLocalStorage)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        } else {
            print("Error: invalid filename")
        }
        
        
    }
    
    
    
}
