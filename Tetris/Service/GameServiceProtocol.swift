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
    var nextTetromino: Tetromino? { get }
    var delegate: GameServiceDelegate? { get set }
    var currentScore: Int { get }
    
    func initGame(rows: Int, columns: Int)
    func startGame()
    @discardableResult func moveLeft() -> Bool
    @discardableResult func moveRight() -> Bool
    @discardableResult func moveDown() -> Bool
    @discardableResult func rotate() -> Bool
    func getColorOfSquare(_ square: Square) -> UIColor?
}
