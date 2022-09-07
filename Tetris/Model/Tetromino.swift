//
//  Tetromino.swift
//  Tetris
//
//  Created by Pau Sabé Martínez on 5/9/22.
//

import Foundation
import SwiftUI

protocol Tetromino{
    var firstSquare: Square { get set }
    var secondSquare: Square { get set }
    var thirdSquare: Square { get set }
    var fourthSquare: Square { get set }
    var color: Color { get }
    
    func setSquaresByFirstSquare(firstSquareRow: Int, firstSquareColumn: Int)
}

struct Square{
    var boardRow = 0
    var boardColumn = 0
}

class StraightTetromino: Tetromino{
    var firstSquare = Square()
    var secondSquare = Square()
    var thirdSquare = Square()
    var fourthSquare = Square()
    let color = Color.blue
    
    func setSquaresByFirstSquare(firstSquareRow: Int, firstSquareColumn: Int){
        firstSquare.boardRow = firstSquareRow
        firstSquare.boardColumn = firstSquareColumn
        secondSquare.boardRow = firstSquare.boardRow
        secondSquare.boardColumn = firstSquare.boardColumn + 1
        thirdSquare.boardRow = firstSquare.boardRow
        thirdSquare.boardColumn = firstSquare.boardColumn + 2
        fourthSquare.boardRow = firstSquare.boardRow
        fourthSquare.boardColumn = firstSquare.boardColumn + 3
    }
}

class SquareTetromino: Tetromino{
    var firstSquare = Square()
    var secondSquare = Square()
    var thirdSquare = Square()
    var fourthSquare = Square()
    let color = Color.yellow
    
    func setSquaresByFirstSquare(firstSquareRow: Int, firstSquareColumn: Int){
        firstSquare.boardRow = firstSquareRow
        firstSquare.boardColumn = firstSquareColumn
        secondSquare.boardRow = firstSquare.boardRow
        secondSquare.boardColumn = firstSquare.boardColumn + 1
        thirdSquare.boardRow = firstSquare.boardRow + 1
        thirdSquare.boardColumn = firstSquare.boardColumn
        fourthSquare.boardRow = firstSquare.boardRow + 1
        fourthSquare.boardColumn = firstSquare.boardColumn + 1
    }
}

class TTetromino: Tetromino{
    var firstSquare = Square()
    var secondSquare = Square()
    var thirdSquare = Square()
    var fourthSquare = Square()
    let color = Color.purple
    
    func setSquaresByFirstSquare(firstSquareRow: Int, firstSquareColumn: Int){
        firstSquare.boardRow = firstSquareRow
        firstSquare.boardColumn = firstSquareColumn
        secondSquare.boardRow = firstSquare.boardRow
        secondSquare.boardColumn = firstSquare.boardColumn + 1
        thirdSquare.boardRow = firstSquare.boardRow
        thirdSquare.boardColumn = firstSquare.boardColumn + 2
        fourthSquare.boardRow = firstSquare.boardRow + 1
        fourthSquare.boardColumn = firstSquare.boardColumn + 1
    }
}

class LTetromino: Tetromino{
    var firstSquare = Square()
    var secondSquare = Square()
    var thirdSquare = Square()
    var fourthSquare = Square()
    let color = Color.orange
    
    func setSquaresByFirstSquare(firstSquareRow: Int, firstSquareColumn: Int){
        firstSquare.boardRow = firstSquareRow
        firstSquare.boardColumn = firstSquareColumn
        secondSquare.boardRow = firstSquare.boardRow + 1
        secondSquare.boardColumn = firstSquare.boardColumn
        thirdSquare.boardRow = firstSquare.boardRow + 2
        thirdSquare.boardColumn = firstSquare.boardColumn
        fourthSquare.boardRow = firstSquare.boardRow + 3
        fourthSquare.boardColumn = firstSquare.boardColumn + 1
    }
}

class SkewTetromino: Tetromino{
    var firstSquare = Square()
    var secondSquare = Square()
    var thirdSquare = Square()
    var fourthSquare = Square()
    let color = Color.green
    
    func setSquaresByFirstSquare(firstSquareRow: Int, firstSquareColumn: Int){
        firstSquare.boardRow = firstSquareRow
        firstSquare.boardColumn = firstSquareColumn
        secondSquare.boardRow = firstSquare.boardRow + 1
        secondSquare.boardColumn = firstSquare.boardColumn
        thirdSquare.boardRow = firstSquare.boardRow + 2
        thirdSquare.boardColumn = firstSquare.boardColumn + 1
        fourthSquare.boardRow = firstSquare.boardRow + 3
        fourthSquare.boardColumn = firstSquare.boardColumn + 1
    }
}
