//
//  StepsServiceProtocol.swift
//  Tetris
//
//  Created by Pau Sabé Martínez on 5/9/22.
//

import Foundation

protocol GameServiceProtocol{
    var currentState: GameState { get }
    var currentTetromino: Tetrominio? { get }
    
    func play()
    func pause()
    func stop()
}
