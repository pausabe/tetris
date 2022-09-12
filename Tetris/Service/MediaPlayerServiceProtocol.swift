//
//  MediaPlayerServiceProtocol.swift
//  Tetris
//
//  Created by Pau Sabé Martínez on 5/9/22.
//

import Foundation

protocol MediaPlayerServiceProtocol {
    func play(songName: String, resourceExtension: String)
    func stop()
}
