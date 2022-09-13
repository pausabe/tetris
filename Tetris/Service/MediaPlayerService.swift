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
    
    static var mp3Extension = "mp3"
    
    func play(songName: String, resourceExtension: String) {
        let url = Bundle.main.url(forResource: songName, withExtension: resourceExtension)
        audioPlayer = try! AVAudioPlayer(contentsOf: url!)
        if audioPlayer != nil {
            audioPlayer.numberOfLoops = -1
            audioPlayer.play()
        }
    }
    
    func stop(){
        if audioPlayer != nil && audioPlayer.isPlaying{
            audioPlayer.stop()
        }
    }

}
