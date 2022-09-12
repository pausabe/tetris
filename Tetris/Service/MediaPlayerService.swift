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
    
    func play(songName: String, resourceExtension: String) {
        // TODO: loop song
        // TODO: stop when minimized
        let url = Bundle.main.url(forResource: songName, withExtension: resourceExtension)
        audioPlayer = try! AVAudioPlayer(contentsOf: url!)
        audioPlayer.play()
    }
    
    func stop(){
        audioPlayer.stop()
    }

}
