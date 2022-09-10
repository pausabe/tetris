//
//  TetrominoServiceMock.swift
//  TetrisTests
//
//  Created by Pau Sabé Martínez on 7/9/22.
//

import Foundation
@testable import Tetris

class TetrominoHelperMock : TetrominoHelperProtocol{
    var randomTetromino: Int?
    
    func newRandomTetromino(_ startingRow: Int, _ startingColumn: Int) -> Tetromino {
        if randomTetromino == nil{
            randomTetromino = Int.random(in: 1...7)
        }
        switch(randomTetromino){
        case 1:
            return LTetromino(startingRow, startingColumn)
        case 2:
            return LTetrominoInverted(startingRow, startingColumn)
        case 3:
            return SkewTetromino(startingRow, startingColumn)
        case 4:
            return SkewTetrominoInverted(startingRow, startingColumn)
        case 5:
            return TTetromino(startingRow, startingColumn)
        case 6:
            return StraightTetromino(startingRow, startingColumn)
        case 7:
            return SquareTetromino(startingRow, startingColumn)
        default:
            return StraightTetromino(startingRow, startingColumn)
        }
    }
}
