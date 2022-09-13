//
//  BoardServiceTests.swift
//  TetrisTests
//
//  Created by Pau Sabé Martínez on 6/9/22.
//

import XCTest
@testable import Tetris

class BoardServiceTests: XCTestCase {
    
    var boardService: BoardService? = nil
    var tetromino: Tetromino? = nil
    
    override func setUp() {
        setFirstTetrominoInPlace()
    }

    func testSetTetromino() throws {
        XCTAssertNotNil(boardService!.board!.map[tetromino!.squares.firstSquare.row][tetromino!.squares.firstSquare.column])
        XCTAssertNotNil(boardService!.board!.map[tetromino!.squares.secondSquare.row][tetromino!.squares.secondSquare.column])
        XCTAssertNotNil(boardService!.board!.map[tetromino!.squares.thirdSquare.row][tetromino!.squares.thirdSquare.column])
        XCTAssertNotNil(boardService!.board!.map[tetromino!.squares.fourthSquare.row][tetromino!.squares.fourthSquare.column])
    }
    
    func setFirstTetrominoInPlace(){
        boardService = BoardService()
        boardService?.initBoardMap(rows: 20, columns: 10)
        tetromino = StraightTetromino(boardService!.tetrominoStartingRow,
                                      boardService!.tetrominoStartingColumn)
        XCTAssertTrue(boardService!.moveTetromino(original: tetromino!.squares, desired: tetromino!.squares, color: tetromino!.color))
    }
    
    func testCorrectTetrominoMovement() throws {
        let oldRow = tetromino!.squares.firstSquare.row
        let column = tetromino!.squares.firstSquare.column
        let desiredSquares = TetrominoSquares(
            firstSquare: Square(tetromino!.squares.firstSquare.row + 1, tetromino!.squares.firstSquare.column),
            secondSquare: Square(tetromino!.squares.secondSquare.row + 1, tetromino!.squares.secondSquare.column),
            thirdSquare: Square(tetromino!.squares.thirdSquare.row + 1, tetromino!.squares.thirdSquare.column),
            fourthSquare: Square(tetromino!.squares.fourthSquare.row + 1, tetromino!.squares.fourthSquare.column))
        
        let movementResult = boardService!.moveTetromino(original: tetromino!.squares, desired: desiredSquares, color: tetromino!.color)
                                                            
        XCTAssertTrue(movementResult)
        XCTAssertNil(boardService!.board!.map[oldRow][column])
        XCTAssertNotNil(boardService!.board!.map[oldRow + 1][column])
    }
    
    func testOutsideBoardTetrominoMovement() throws {
        let originalRow = tetromino!.squares.firstSquare.row
        let originaColumn = tetromino!.squares.firstSquare.column
        
        let squaresDesired = TetrominoSquares(
            firstSquare: Square(tetromino!.squares.firstSquare.row, tetromino!.squares.firstSquare.column + boardService!.board!.rowNumber),
            secondSquare: Square(tetromino!.squares.secondSquare.row, tetromino!.squares.secondSquare.column + boardService!.board!.rowNumber),
            thirdSquare: Square(tetromino!.squares.thirdSquare.row, tetromino!.squares.thirdSquare.column + boardService!.board!.rowNumber),
            fourthSquare: Square(tetromino!.squares.fourthSquare.row, tetromino!.squares.fourthSquare.column + boardService!.board!.rowNumber))
        
        let movementResult = boardService!.moveTetromino(original: tetromino!.squares, desired: squaresDesired, color: tetromino!.color)

        XCTAssertFalse(movementResult)
        XCTAssertNotNil(boardService!.board!.map[originalRow][originaColumn])
    }
    
    func testCollidingTetrominoMovement() throws {
        // Placing a Square below the Straight one
        let desiredSquares = SquareTetromino(boardService!.tetrominoStartingRow, boardService!.tetrominoStartingColumn).getDesiredSquares(.down)
        XCTAssertTrue(boardService!.moveTetromino(original: nil,
                                    desired: desiredSquares,
                                    color: .blue))
        
        // Moving the Straight oveooor the Square
        let desiredSquares2 = tetromino!.getDesiredSquares(.down)
        XCTAssertFalse(boardService!.moveTetromino(
            original: tetromino!.squares,
            desired: desiredSquares2,
            color: tetromino!.color))
    }
    
    func testClearFullRow() throws {
        let maximumSquareTetromino = boardService!.board!.columnNumber / 2
        for i in 0...(maximumSquareTetromino - 1){
            let newTetromino = TetrominoSquares(
                firstSquare: Square(boardService!.board!.rowNumber - 3, i * 2),
                secondSquare: Square(boardService!.board!.rowNumber - 2, (i * 2) + 1),
                thirdSquare: Square(boardService!.board!.rowNumber - 3, i * 2),
                fourthSquare: Square(boardService!.board!.rowNumber - 2, (i * 2) + 1))
            XCTAssertTrue(boardService!.moveTetromino(original: newTetromino, desired: newTetromino, color: .blue))
        }
        let tetrominoAtFilledRows = TetrominoSquares(
            firstSquare: Square(boardService!.board!.rowNumber - 3, 0),
            secondSquare: Square(boardService!.board!.rowNumber - 2, 1),
            thirdSquare: Square(boardService!.board!.rowNumber - 3, 0),
            fourthSquare: Square(boardService!.board!.rowNumber - 2, 1))
        XCTAssertTrue(boardService!.moveTetromino(original: tetrominoAtFilledRows, desired: tetrominoAtFilledRows, color: .blue))
        XCTAssertNil(boardService!.board!.map[boardService!.board!.rowNumber - 2][0])
        XCTAssertNil(boardService!.board!.map[boardService!.board!.rowNumber - 1][0])
    }
    
    func testRotationCorrect() throws {
        let desiredSquares = tetromino!.getDesiredSquares(.rotation)
        XCTAssertTrue(boardService!.moveTetromino(
            original: tetromino!.squares,
            desired: desiredSquares,
            color: .blue))
    }
    
    func testRotationIncorrect() throws {
        // Move straight to bottom
        let desiredSquares = TetrominoSquares(
            firstSquare: Square(boardService!.board!.rowNumber - 2, 0),
            secondSquare: Square(boardService!.board!.rowNumber - 2, 1),
            thirdSquare: Square(boardService!.board!.rowNumber - 2, 0),
            fourthSquare: Square(boardService!.board!.rowNumber - 2, 1))
        XCTAssertTrue(boardService!.moveTetromino(original: tetromino!.squares, desired: desiredSquares, color: tetromino!.color))
        tetromino!.move(desiredSquares)
        
        // Rotate
        let desiredSquares2 = tetromino!.getDesiredSquares(.rotation)
        XCTAssertFalse(boardService!.moveTetromino(original: tetromino!.squares, desired: desiredSquares2, color: tetromino!.color))
    }
    
    func testRotateMoreThanOne() throws{
        let startingRow = boardService!.tetrominoStartingRow + 5
        let startingColumn = boardService!.tetrominoStartingColumn
        let originalSquares = tetromino!.squares
        tetromino = LTetromino(startingRow, startingColumn)
        XCTAssertTrue(boardService!.moveTetromino(
            original: originalSquares,
            desired: tetromino!.squares,
            color: tetromino!.color))
        for _ in 1...tetromino!.rotations.count{
            XCTAssertTrue(boardService!.moveTetromino(
                original: tetromino!.squares,
                desired: tetromino!.getDesiredSquares(.rotation),
                color: tetromino!.color))
            tetromino!.move(.rotation)
        }
    }
    
}
