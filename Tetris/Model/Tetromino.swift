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
    var rotations: [Rotation] { get }
    var currentRotation: Int { get set }
    
    init(_ firstSquareRow: Int, _ firstSquareColumn: Int)
}

extension Tetromino{
    mutating func move(_ direction: MovementDirectionEnum){
        switch direction {
        case .left:
            squares = getDesiredSquares(direction)
        case .right:
            squares = getDesiredSquares(direction)
        case .down:
            squares = getDesiredSquares(direction)
        case .rotation:
            squares = getDesiredSquares(direction)
            currentRotation += 1
            if currentRotation == rotations.count{
                currentRotation = 0
            }
        }
    }
    
    mutating func move(_ squares: TetrominoSquares){
        self.squares = squares
    }
    
    func getDesiredSquares(_ direction: MovementDirectionEnum) -> TetrominoSquares{
        var desiredSquares: TetrominoSquares?
        
        switch direction {
        case .left:
            desiredSquares = TetrominoSquares(
                firstSquare: Square(squares.firstSquare.row, squares.firstSquare.column - 1),
                secondSquare: Square(squares.secondSquare.row, squares.secondSquare.column - 1),
                thirdSquare: Square(squares.thirdSquare.row, squares.thirdSquare.column - 1),
                fourthSquare: Square(squares.fourthSquare.row, squares.fourthSquare.column - 1))
        case .right:
            desiredSquares = TetrominoSquares(
                firstSquare: Square(squares.firstSquare.row, squares.firstSquare.column + 1),
                secondSquare: Square(squares.secondSquare.row, squares.secondSquare.column + 1),
                thirdSquare: Square(squares.thirdSquare.row, squares.thirdSquare.column + 1),
                fourthSquare: Square(squares.fourthSquare.row, squares.fourthSquare.column + 1))
        case .down:
            desiredSquares = TetrominoSquares(
                firstSquare: Square(squares.firstSquare.row + 1, squares.firstSquare.column),
                secondSquare: Square(squares.secondSquare.row + 1, squares.secondSquare.column),
                thirdSquare: Square(squares.thirdSquare.row + 1, squares.thirdSquare.column),
                fourthSquare: Square(squares.fourthSquare.row + 1, squares.fourthSquare.column))
        case .rotation:
            var nextRotation = currentRotation + 1
            if nextRotation == rotations.count{
                nextRotation = 0
            }
            let firstRowDifference = rotations[nextRotation].tetrominoSquares.firstSquare.row - rotations[currentRotation].tetrominoSquares.firstSquare.row
            let firstColumnDifference = rotations[nextRotation].tetrominoSquares.firstSquare.column - rotations[currentRotation].tetrominoSquares.firstSquare.column
            let secondRowDifference = rotations[nextRotation].tetrominoSquares.secondSquare.row - rotations[currentRotation].tetrominoSquares.secondSquare.row
            let seconColumnDifference = rotations[nextRotation].tetrominoSquares.secondSquare.column - rotations[currentRotation].tetrominoSquares.secondSquare.column
            let thirdRowDifference = rotations[nextRotation].tetrominoSquares.thirdSquare.row - rotations[currentRotation].tetrominoSquares.thirdSquare.row
            let thirdColumnDifference = rotations[nextRotation].tetrominoSquares.thirdSquare.column - rotations[currentRotation].tetrominoSquares.thirdSquare.column
            let fourthRowDifference = rotations[nextRotation].tetrominoSquares.fourthSquare.row - rotations[currentRotation].tetrominoSquares.fourthSquare.row
            let fourthColumnDifference = rotations[nextRotation].tetrominoSquares.fourthSquare.column - rotations[currentRotation].tetrominoSquares.fourthSquare.column
        
            desiredSquares = TetrominoSquares(
                firstSquare: Square(squares.firstSquare.row + firstRowDifference, squares.firstSquare.column + firstColumnDifference),
                secondSquare: Square(squares.secondSquare.row + secondRowDifference, squares.secondSquare.column + seconColumnDifference),
                thirdSquare: Square(squares.thirdSquare.row + thirdRowDifference, squares.thirdSquare.column + thirdColumnDifference),
                fourthSquare: Square(squares.fourthSquare.row + fourthRowDifference, squares.fourthSquare.column + fourthColumnDifference))
        }
        
        return desiredSquares!
    }
}

struct Square{
    var row: Int
    var column: Int
    
    init(_ row: Int = 0, _ column: Int = 0){
        self.row = row
        self.column = column
    }
}

struct TetrominoSquares{
    var firstSquare = Square()
    var secondSquare = Square()
    var thirdSquare = Square()
    var fourthSquare = Square()
}

struct Rotation{
    var tetrominoSquares = TetrominoSquares()
    init(_ firstSquare: Square, _ secondSquare: Square, _ thirdSquare: Square, _ fourthSquare: Square){
        tetrominoSquares.firstSquare = firstSquare
        tetrominoSquares.secondSquare = secondSquare
        tetrominoSquares.thirdSquare = thirdSquare
        tetrominoSquares.fourthSquare = fourthSquare
    }
}

// TODO: integration test to check that the first Square of the first rotation of every Tetromino must be 0, 0

class LTetromino: Tetromino{
    var squares = TetrominoSquares()
    let color = ViewHelper.getColorByHex(rgbHexValue: ColorKeys.LTetromino)
    var rotations = [Rotation]()
    var currentRotation: Int = 0
    
    required init(_ firstSquareRow: Int, _ firstSquareColumn: Int){
        // Declare rotations
        rotations.append(Rotation(Square(0, 0), Square(0, 1), Square(0, 2), Square(1, 2)))
        rotations.append(Rotation(Square(2, 0), Square(1, 0), Square(0, 0), Square(0, 1)))
        rotations.append(Rotation(Square(1, 2), Square(1, 1), Square(1, 0), Square(0, 0)))
        rotations.append(Rotation(Square(0, 1), Square(1, 1), Square(2, 1), Square(2, 0)))
        
        // Set rotation 0
        squares.firstSquare.row = firstSquareRow
        squares.firstSquare.column = firstSquareColumn
        squares.secondSquare.row = firstSquareRow + rotations[0].tetrominoSquares.secondSquare.row
        squares.secondSquare.column = firstSquareColumn + rotations[0].tetrominoSquares.secondSquare.column
        squares.thirdSquare.row = firstSquareRow + rotations[0].tetrominoSquares.thirdSquare.row
        squares.thirdSquare.column = firstSquareColumn + rotations[0].tetrominoSquares.thirdSquare.column
        squares.fourthSquare.row = firstSquareRow + rotations[0].tetrominoSquares.fourthSquare.row
        squares.fourthSquare.column = firstSquareColumn + rotations[0].tetrominoSquares.fourthSquare.column
    }
}

class LTetrominoInverted: Tetromino{
    var squares = TetrominoSquares()
    let color = ViewHelper.getColorByHex(rgbHexValue: ColorKeys.LTetrominoInverted)
    var rotations = [Rotation]()
    var currentRotation: Int = 0
    
    required init(_ firstSquareRow: Int, _ firstSquareColumn: Int){
        // Declare rotations
        rotations.append(Rotation(Square(0, 0), Square(1, 0), Square(2, 0), Square(2, 1)))
        rotations.append(Rotation(Square(0, 2), Square(0, 1), Square(0, 0), Square(1, 0)))
        rotations.append(Rotation(Square(2, 1), Square(1, 1), Square(0, 1), Square(0, 0)))
        rotations.append(Rotation(Square(1, 0), Square(1, 1), Square(1, 2), Square(0, 2)))
        
        // Set rotation 0
        squares.firstSquare.row = firstSquareRow
        squares.firstSquare.column = firstSquareColumn
        squares.secondSquare.row = firstSquareRow + rotations[0].tetrominoSquares.secondSquare.row
        squares.secondSquare.column = firstSquareColumn + rotations[0].tetrominoSquares.secondSquare.column
        squares.thirdSquare.row = firstSquareRow + rotations[0].tetrominoSquares.thirdSquare.row
        squares.thirdSquare.column = firstSquareColumn + rotations[0].tetrominoSquares.thirdSquare.column
        squares.fourthSquare.row = firstSquareRow + rotations[0].tetrominoSquares.fourthSquare.row
        squares.fourthSquare.column = firstSquareColumn + rotations[0].tetrominoSquares.fourthSquare.column
    }
}

class SkewTetromino: Tetromino{
    var squares = TetrominoSquares()
    let color = ViewHelper.getColorByHex(rgbHexValue: ColorKeys.skewTetromino)
    var rotations = [Rotation]()
    var currentRotation: Int = 0
    
    required init(_ firstSquareRow: Int, _ firstSquareColumn: Int){
        // Declare rotations
        rotations.append(Rotation(Square(0, 0), Square(1, 0), Square(1, 1), Square(2, 1)))
        rotations.append(Rotation(Square(0, 2), Square(0, 1), Square(1, 1), Square(1, 0)))
        
        // Set rotation 0
        squares.firstSquare.row = firstSquareRow
        squares.firstSquare.column = firstSquareColumn
        squares.secondSquare.row = firstSquareRow + rotations[0].tetrominoSquares.secondSquare.row
        squares.secondSquare.column = firstSquareColumn + rotations[0].tetrominoSquares.secondSquare.column
        squares.thirdSquare.row = firstSquareRow + rotations[0].tetrominoSquares.thirdSquare.row
        squares.thirdSquare.column = firstSquareColumn + rotations[0].tetrominoSquares.thirdSquare.column
        squares.fourthSquare.row = firstSquareRow + rotations[0].tetrominoSquares.fourthSquare.row
        squares.fourthSquare.column = firstSquareColumn + rotations[0].tetrominoSquares.fourthSquare.column
    }
}

class SkewTetrominoInverted: Tetromino{
    var squares = TetrominoSquares()
    let color = ViewHelper.getColorByHex(rgbHexValue: ColorKeys.skewTetrominoInverted)
    var rotations = [Rotation]()
    var currentRotation: Int = 0
    
    required init(_ firstSquareRow: Int, _ firstSquareColumn: Int){
        // Declare rotations
        rotations.append(Rotation(Square(0, 0), Square(0, 1), Square(1, 1), Square(1, 2)))
        rotations.append(Rotation(Square(0, 1), Square(1, 1), Square(1, 0), Square(2, 0)))
        
        // Set rotation 0
        squares.firstSquare.row = firstSquareRow
        squares.firstSquare.column = firstSquareColumn
        squares.secondSquare.row = firstSquareRow + rotations[0].tetrominoSquares.secondSquare.row
        squares.secondSquare.column = firstSquareColumn + rotations[0].tetrominoSquares.secondSquare.column
        squares.thirdSquare.row = firstSquareRow + rotations[0].tetrominoSquares.thirdSquare.row
        squares.thirdSquare.column = firstSquareColumn + rotations[0].tetrominoSquares.thirdSquare.column
        squares.fourthSquare.row = firstSquareRow + rotations[0].tetrominoSquares.fourthSquare.row
        squares.fourthSquare.column = firstSquareColumn + rotations[0].tetrominoSquares.fourthSquare.column
    }
}

class TTetromino: Tetromino{
    var squares = TetrominoSquares()
    let color = ViewHelper.getColorByHex(rgbHexValue: ColorKeys.TTetromino)
    var rotations = [Rotation]()
    var currentRotation: Int = 0
    
    required init(_ firstSquareRow: Int, _ firstSquareColumn: Int){
        // Declare rotations
        rotations.append(Rotation(Square(0, 0), Square(0, 1), Square(0, 2), Square(1, 1)))
        rotations.append(Rotation(Square(2, 0), Square(1, 0), Square(0, 0), Square(1, 1)))
        rotations.append(Rotation(Square(2, 2), Square(2, 1), Square(2, 0), Square(1, 1)))
        rotations.append(Rotation(Square(0, 1), Square(1, 1), Square(2, 1), Square(1, 0)))
        
        // Set rotation 0
        squares.firstSquare.row = firstSquareRow
        squares.firstSquare.column = firstSquareColumn
        squares.secondSquare.row = firstSquareRow + rotations[0].tetrominoSquares.secondSquare.row
        squares.secondSquare.column = firstSquareColumn + rotations[0].tetrominoSquares.secondSquare.column
        squares.thirdSquare.row = firstSquareRow + rotations[0].tetrominoSquares.thirdSquare.row
        squares.thirdSquare.column = firstSquareColumn + rotations[0].tetrominoSquares.thirdSquare.column
        squares.fourthSquare.row = firstSquareRow + rotations[0].tetrominoSquares.fourthSquare.row
        squares.fourthSquare.column = firstSquareColumn + rotations[0].tetrominoSquares.fourthSquare.column
    }
}

class StraightTetromino: Tetromino{
    var squares = TetrominoSquares()
    let color = ViewHelper.getColorByHex(rgbHexValue: ColorKeys.straightTetromino)
    var rotations = [Rotation]()
    var currentRotation: Int = 0
    
    required init(_ firstSquareRow: Int, _ firstSquareColumn: Int){
        // Declare rotations
        rotations.append(Rotation(Square(0, 0), Square(0, 1), Square(0, 2), Square(0, 3)))
        rotations.append(Rotation(Square(0, 0), Square(1, 0), Square(2, 0), Square(3, 0)))
        
        // Set rotation 0
        squares.firstSquare.row = firstSquareRow
        squares.firstSquare.column = firstSquareColumn
        squares.secondSquare.row = firstSquareRow + rotations[0].tetrominoSquares.secondSquare.row
        squares.secondSquare.column = firstSquareColumn + rotations[0].tetrominoSquares.secondSquare.column
        squares.thirdSquare.row = firstSquareRow + rotations[0].tetrominoSquares.thirdSquare.row
        squares.thirdSquare.column = firstSquareColumn + rotations[0].tetrominoSquares.thirdSquare.column
        squares.fourthSquare.row = firstSquareRow + rotations[0].tetrominoSquares.fourthSquare.row
        squares.fourthSquare.column = firstSquareColumn + rotations[0].tetrominoSquares.fourthSquare.column
    }
}

class SquareTetromino: Tetromino{
    var squares = TetrominoSquares()
    let color = ViewHelper.getColorByHex(rgbHexValue: ColorKeys.squareTetromino)
    var rotations = [Rotation]()
    var currentRotation: Int = 0
    
    required init(_ firstSquareRow: Int, _ firstSquareColumn: Int){
        // Declare rotations
        rotations.append(Rotation(Square(0, 0), Square(0, 1), Square(1, 0), Square(1, 1)))
        
        // Set rotation 0
        squares.firstSquare.row = firstSquareRow
        squares.firstSquare.column = firstSquareColumn
        squares.secondSquare.row = firstSquareRow + rotations[0].tetrominoSquares.secondSquare.row
        squares.secondSquare.column = firstSquareColumn + rotations[0].tetrominoSquares.secondSquare.column
        squares.thirdSquare.row = firstSquareRow + rotations[0].tetrominoSquares.thirdSquare.row
        squares.thirdSquare.column = firstSquareColumn + rotations[0].tetrominoSquares.thirdSquare.column
        squares.fourthSquare.row = firstSquareRow + rotations[0].tetrominoSquares.fourthSquare.row
        squares.fourthSquare.column = firstSquareColumn + rotations[0].tetrominoSquares.fourthSquare.column
    }
}
