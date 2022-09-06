//
//  BoardServiceProtocol.swift
//  Tetris
//
//  Created by Pau Sabé Martínez on 6/9/22.
//

import Foundation

protocol BoardServiceProtocol{
    var tetrominoStartingColumn: Int { get }
    var tetrominoStartingRow: Int { get }
    
    func setTetrominoInBoard(tetromino: Tetrominio)
}
