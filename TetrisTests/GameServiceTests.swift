//
//  TetrisTests.swift
//  TetrisTests
//
//  Created by Pau Sabé Martínez on 6/9/22.
//

import XCTest
@testable import Tetris

class GameServiceTests: XCTestCase {
    
    var gameService: GameServiceProtocol! = nil
    
    override func setUp() {
        // TODO: mock Timer Service
        gameService = GameService()
    }
    
    func testStartGame() throws {
        startGame()
    }
    
    func startGame() {
        XCTAssertEqual(gameService.currentState, GameState.stopped)
        XCTAssertNil(gameService.currentTetromino)
        
        gameService!.play()
        
        XCTAssertNotNil(gameService.currentTetromino)
        XCTAssertEqual(gameService.currentState, GameState.running)
    }

    func testOneHorizontalMovement() throws {
        startGame()
        let startingTetrominoColumn = gameService.currentTetromino!.firstSquare.boardColumn
        XCTAssertTrue(gameService!.moveLeft())
        let movedTetrominoColumn = gameService.currentTetromino!.firstSquare.boardColumn
        XCTAssertEqual(startingTetrominoColumn, movedTetrominoColumn - 1)
    }
    
    func testTimerTickMakesTetrominoGoDown() throws{
        
    }

}
