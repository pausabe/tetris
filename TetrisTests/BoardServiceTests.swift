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
        XCTAssertNotNil(boardService!.board!.map[tetromino!.squares.firstSquare.boardRow][tetromino!.squares.firstSquare.boardColumn])
        XCTAssertNotNil(boardService!.board!.map[tetromino!.squares.secondSquare.boardRow][tetromino!.squares.secondSquare.boardColumn])
        XCTAssertNotNil(boardService!.board!.map[tetromino!.squares.thirdSquare.boardRow][tetromino!.squares.thirdSquare.boardColumn])
        XCTAssertNotNil(boardService!.board!.map[tetromino!.squares.fourthSquare.boardRow][tetromino!.squares.fourthSquare.boardColumn])
    }
    
    func setFirstTetrominoInPlace(){
        boardService = BoardService(rows: 20, columns: 10)
        tetromino = StraightTetromino()
        
        tetromino!.setSquaresByFirstSquare(
            firstSquareRow: boardService!.tetrominoStartingRow,
            firstSquareColumn: boardService!.tetrominoStartingColumn)
        boardService!.setTetrominoInBoard(tetromino: tetromino!)
    }
    
    func testCorrectTetrominoMovement() throws {
        let oldRow = tetromino!.squares.firstSquare.boardRow
        let newRow = oldRow + 1
        let column = tetromino!.squares.firstSquare.boardColumn
        let movementResult = boardService!.moveTetromino(tetromino: tetromino!, newStartingTetrominoRow: newRow, newStartingTetrominoColumn: column)
        XCTAssertTrue(movementResult)
        XCTAssertNil(boardService!.board!.map[oldRow][column])
        XCTAssertNotNil(boardService!.board!.map[newRow][column])
    }
    
    func testOutsideBoardTetrominoMovement() throws {
        let row = tetromino!.squares.firstSquare.boardRow
        let column = tetromino!.squares.firstSquare.boardColumn
        let movementResult = boardService!.moveTetromino(tetromino: tetromino!, newStartingTetrominoRow: row + boardService!.board!.rowNumber, newStartingTetrominoColumn: column)
        XCTAssertFalse(movementResult)
        XCTAssertNotNil(boardService!.board!.map[row][column])
    }
    
    func testCollidingTetrominoMovement() throws {
        // Placing a Square below the Straight one
        let secondTetromino = SquareTetromino()
        let firstMovementResult = boardService!.moveTetromino(tetromino: secondTetromino, newStartingTetrominoRow: tetromino!.squares.firstSquare.boardRow + 1, newStartingTetrominoColumn: tetromino!.squares.firstSquare.boardColumn)
        XCTAssertTrue(firstMovementResult)
        
        // Moving the Straight over the Square
        let secondMovementResult = boardService!.moveTetromino(tetromino: tetromino!, newStartingTetrominoRow: tetromino!.squares.firstSquare.boardRow + 1, newStartingTetrominoColumn: tetromino!.squares.firstSquare.boardColumn)
        XCTAssertFalse(secondMovementResult)
    }
}
