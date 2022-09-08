//
//  StepsServiceProtocol.swift
//  Tetris
//
//  Created by Pau Sabé Martínez on 5/9/22.
//

import Foundation

protocol GameServiceProtocol{
    var currentState: GameState { get }
    var currentTetromino: Tetromino? { get }
    var delegate: GameServiceDelegate? { get set }
    
    func play()
    func pause()
    func stop()
    @discardableResult func moveLeft() -> Bool
    @discardableResult func moveRight() -> Bool
}
