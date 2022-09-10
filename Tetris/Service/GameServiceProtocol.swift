//
//  StepsServiceProtocol.swift
//  Tetris
//
//  Created by Pau Sabé Martínez on 5/9/22.
//

import Foundation
import UIKit

protocol GameServiceProtocol{
    var currentState: GameState { get }
    var currentTetromino: Tetromino? { get }
    var delegate: GameServiceDelegate? { get set }
    var currentScore: Int { get }
    
    func play()
    func pause()
    func stop()
    @discardableResult func moveLeft() -> Bool
    @discardableResult func moveRight() -> Bool
    @discardableResult func moveDown() -> Bool
    @discardableResult func rotate() -> Bool
    func getColorOfSquare(_ square: Square) -> UIColor?
}
