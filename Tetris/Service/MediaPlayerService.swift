//
//  MediaPlayerService.swift
//  Tetris
//
//  Created by Pau Sabé Martínez on 3/9/22.
//

import Foundation
import AVFoundation

class MediaPlayerService : MediaPlayerServiceProtocol{
    var audioPlayer : AVAudioPlayer!
    
    var test = "default"
    
    func playSoundtrack() {
        // TODO: loop song
        // TODO: stop when minimized
        let url = Bundle.main.url(forResource: "tetris_soundtrack", withExtension: "mp3")
        audioPlayer = try! AVAudioPlayer(contentsOf: url!)
        audioPlayer.play()
    }

}
