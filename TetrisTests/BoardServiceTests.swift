//
//  BoardServiceTests.swift
//  TetrisTests
//
//  Created by Pau Sabé Martínez on 6/9/22.
//

import XCTest
@testable import Tetris

class BoardServiceTests: XCTestCase {

    func testSetTetromino() throws {
        let boardService = BoardService()
        let tetromino = StraightTetromino()
        
        tetromino.setSquaresByFirstSquare(
            firstSquareRow: boardService.tetrominoStartingRow,
            firstSquareColumn: boardService.tetrominoStartingColumn)
        boardService.setTetrominoInBoard(tetromino: tetromino)
        
        XCTAssertNotNil(boardService.board?.map[tetromino.firstSquare.boardRow][tetromino.firstSquare.boardColumn])
        XCTAssertNotNil(boardService.board?.map[tetromino.secondSquare.boardRow][tetromino.secondSquare.boardColumn])
        XCTAssertNotNil(boardService.board?.map[tetromino.thirdSquare.boardRow][tetromino.thirdSquare.boardColumn])
        XCTAssertNotNil(boardService.board?.map[tetromino.fourthSquare.boardRow][tetromino.fourthSquare.boardColumn])
    }

}
