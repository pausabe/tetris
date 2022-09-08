//
//  BoardServiceTests.swift
//  TetrisTests
//
//  Created by Pau Sabé Martínez on 6/9/22.
//

import XCTest
@testable import Tetris

class BoardServiceTests: XCTestCase {
    
    var boardService: BoardServiceProtocol? = nil
    var tetromino: Tetromino? = nil
    
    override func setUp() {
        setFirstTetrominoInPlace()
    }

    func testSetTetromino() throws {
        XCTAssertNotNil(boardService!.board!.map[tetromino!.firstSquare.boardRow][tetromino!.firstSquare.boardColumn])
        XCTAssertNotNil(boardService!.board!.map[tetromino!.secondSquare.boardRow][tetromino!.secondSquare.boardColumn])
        XCTAssertNotNil(boardService!.board!.map[tetromino!.thirdSquare.boardRow][tetromino!.thirdSquare.boardColumn])
        XCTAssertNotNil(boardService!.board!.map[tetromino!.fourthSquare.boardRow][tetromino!.fourthSquare.boardColumn])
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
        let oldRow = tetromino!.firstSquare.boardRow
        let newRow = oldRow + 1
        let column = tetromino!.firstSquare.boardColumn
        let movementResult = boardService!.moveTetromino(tetromino: tetromino!, newStartingTetrominoRow: newRow, newStartingTetrominoColumn: column)
        XCTAssertTrue(movementResult)
        XCTAssertNil(boardService!.board!.map[oldRow][column])
        XCTAssertNotNil(boardService!.board!.map[newRow][column])
    }
    
    func testOutsideBoardTetrominoMovement() throws {
        let row = tetromino!.firstSquare.boardRow
        let column = tetromino!.firstSquare.boardColumn
        let movementResult = boardService!.moveTetromino(tetromino: tetromino!, newStartingTetrominoRow: row + boardService!.board!.rowNumber, newStartingTetrominoColumn: column)
        XCTAssertFalse(movementResult)
        XCTAssertNotNil(boardService!.board!.map[row][column])
    }
    
    func testCollidingTetrominoMovement() throws {
        // Placing a Square below the Straight one
        let secondTetromino = SquareTetromino()
        let firstMovementResult = boardService!.moveTetromino(tetromino: secondTetromino, newStartingTetrominoRow: tetromino!.firstSquare.boardRow + 1, newStartingTetrominoColumn: tetromino!.firstSquare.boardColumn)
        XCTAssertTrue(firstMovementResult)
        
        // Moving the Straight over the Square
        let secondMovementResult = boardService!.moveTetromino(tetromino: tetromino!, newStartingTetrominoRow: tetromino!.firstSquare.boardRow + 1, newStartingTetrominoColumn: tetromino!.firstSquare.boardColumn)
        XCTAssertFalse(secondMovementResult)
    }
}
