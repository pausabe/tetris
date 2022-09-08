//
//  BoardServiceProtocol.swift
//  Tetris
//
//  Created by Pau Sabé Martínez on 6/9/22.
//

import Foundation

protocol BoardServiceProtocol{
    var board: Board? { get }
    var tetrominoStartingColumn: Int { get }
    var tetrominoStartingRow: Int { get }
    
    func setTetrominoInStartingPlace(_ tetromino: Tetromino) -> Bool
    //func setTetrominoInBoard(tetromino: Tetromino)
    func moveTetromino(tetromino: Tetromino, newStartingTetrominoRow: Int, newStartingTetrominoColumn: Int) -> Bool
}
