//
//  TetrominoServiceMock.swift
//  TetrisTests
//
//  Created by Pau Sabé Martínez on 7/9/22.
//

import Foundation
@testable import Tetris

class TetrominoServiceMock : TetrominoServiceProtocol{
    var randomTetromino: Int?
    
    func newRandomTetromino() -> Tetromino {
        if randomTetromino == nil{
            randomTetromino = Int.random(in: 1...5)
        }
        switch(randomTetromino){
            case 1:
                return StraightTetromino()
            case 2:
                return SquareTetromino()
            case 3:
                return TTetromino()
            case 4:
                return LTetromino()
            case 5:
                return SkewTetromino()
            default:
                return StraightTetromino()
            }
    }
}
