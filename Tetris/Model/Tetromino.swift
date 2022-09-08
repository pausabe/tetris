//
//  Tetromino.swift
//  Tetris
//
//  Created by Pau Sabé Martínez on 5/9/22.
//

import Foundation
import SwiftUI

protocol Tetromino{
    var squares: TetrominoSquares { get set }
    var color: UIColor { get }
    
    func setSquaresByFirstSquare(firstSquareRow: Int, firstSquareColumn: Int)
}

struct Square{
    var boardRow = 0
    var boardColumn = 0
}

struct TetrominoSquares{
    var firstSquare = Square()
    var secondSquare = Square()
    var thirdSquare = Square()
    var fourthSquare = Square()
}

class StraightTetromino: Tetromino{
    var squares = TetrominoSquares()
    let color = UIColor.blue
    
    func setSquaresByFirstSquare(firstSquareRow: Int, firstSquareColumn: Int){
        squares.firstSquare.boardRow = firstSquareRow
        squares.firstSquare.boardColumn = firstSquareColumn
        squares.secondSquare.boardRow = squares.firstSquare.boardRow
        squares.secondSquare.boardColumn = squares.firstSquare.boardColumn + 1
        squares.thirdSquare.boardRow = squares.firstSquare.boardRow
        squares.thirdSquare.boardColumn = squares.firstSquare.boardColumn + 2
        squares.fourthSquare.boardRow = squares.firstSquare.boardRow
        squares.fourthSquare.boardColumn = squares.firstSquare.boardColumn + 3
    }
}

class SquareTetromino: Tetromino{
    var squares = TetrominoSquares()
    let color = UIColor.yellow
    
    func setSquaresByFirstSquare(firstSquareRow: Int, firstSquareColumn: Int){
        squares.firstSquare.boardRow = firstSquareRow
        squares.firstSquare.boardColumn = firstSquareColumn
        squares.secondSquare.boardRow = squares.firstSquare.boardRow
        squares.secondSquare.boardColumn = squares.firstSquare.boardColumn + 1
        squares.thirdSquare.boardRow = squares.firstSquare.boardRow + 1
        squares.thirdSquare.boardColumn = squares.firstSquare.boardColumn
        squares.fourthSquare.boardRow = squares.firstSquare.boardRow + 1
        squares.fourthSquare.boardColumn = squares.firstSquare.boardColumn + 1
    }
}

class TTetromino: Tetromino{
    var squares = TetrominoSquares()
    let color = UIColor.purple
    
    func setSquaresByFirstSquare(firstSquareRow: Int, firstSquareColumn: Int){
        squares.firstSquare.boardRow = firstSquareRow
        squares.firstSquare.boardColumn = firstSquareColumn
        squares.secondSquare.boardRow = squares.firstSquare.boardRow
        squares.secondSquare.boardColumn = squares.firstSquare.boardColumn + 1
        squares.thirdSquare.boardRow = squares.firstSquare.boardRow
        squares.thirdSquare.boardColumn = squares.firstSquare.boardColumn + 2
        squares.fourthSquare.boardRow = squares.firstSquare.boardRow + 1
        squares.fourthSquare.boardColumn = squares.firstSquare.boardColumn + 1
    }
}

class LTetromino: Tetromino{
    var squares = TetrominoSquares()
    let color = UIColor.orange
    
    func setSquaresByFirstSquare(firstSquareRow: Int, firstSquareColumn: Int){
        squares.firstSquare.boardRow = firstSquareRow
        squares.firstSquare.boardColumn = firstSquareColumn
        squares.secondSquare.boardRow = squares.firstSquare.boardRow + 1
        squares.secondSquare.boardColumn = squares.firstSquare.boardColumn
        squares.thirdSquare.boardRow = squares.firstSquare.boardRow + 2
        squares.thirdSquare.boardColumn = squares.firstSquare.boardColumn
        squares.fourthSquare.boardRow = squares.firstSquare.boardRow + 2
        squares.fourthSquare.boardColumn = squares.firstSquare.boardColumn + 1
    }
}

class SkewTetromino: Tetromino{
    var squares = TetrominoSquares()
    let color = UIColor.green
    
    func setSquaresByFirstSquare(firstSquareRow: Int, firstSquareColumn: Int){
        squares.firstSquare.boardRow = firstSquareRow
        squares.firstSquare.boardColumn = firstSquareColumn
        squares.secondSquare.boardRow = squares.firstSquare.boardRow + 1
        squares.secondSquare.boardColumn = squares.firstSquare.boardColumn
        squares.thirdSquare.boardRow = squares.firstSquare.boardRow + 1
        squares.thirdSquare.boardColumn = squares.firstSquare.boardColumn + 1
        squares.fourthSquare.boardRow = squares.firstSquare.boardRow + 2
        squares.fourthSquare.boardColumn = squares.firstSquare.boardColumn + 1
    }
}
