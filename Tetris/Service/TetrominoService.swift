//
//  TetrominoService.swift
//  Tetris
//
//  Created by Pau Sabé Martínez on 7/9/22.
//

import Foundation

class TetrominoService : TetrominoServiceProtocol {
    func newRandomTetromino() -> Tetromino{
        // TODO: also we should determine the rotation randomly
        switch(Int.random(in: 1...5)){
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
