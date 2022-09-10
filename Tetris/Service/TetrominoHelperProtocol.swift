//
//  TetrominoServiceProtocol.swift
//  Tetris
//
//  Created by Pau Sabé Martínez on 7/9/22.
//

import Foundation

protocol TetrominoHelperProtocol{
    func newRandomTetromino(_ startingRow: Int, _ startingColumn: Int) -> Tetromino
}
