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
    var tetrominoServiceMock: TetrominoServiceMock! = nil
    var timerService: TimerServiceMock! = nil
    let rows = 20
    let columns = 10
    
    override func setUp() {
        tetrominoServiceMock = TetrominoServiceMock()
        timerService = TimerServiceMock()
        gameService = GameService(
            timerService: timerService,
            boardService: BoardService(rows: rows, columns: columns),
            tetrominoService: tetrominoServiceMock)
    }
    
    func testStartGame() throws {
        startGame()
    }
    
    func startGame(randomTetromino: Int? = nil) {
        XCTAssertEqual(gameService.currentState, GameState.stopped)
        XCTAssertNil(gameService.currentTetromino)
        
        tetrominoServiceMock.randomTetromino = randomTetromino
        gameService!.play()
        
        XCTAssertNotNil(gameService.currentTetromino)
        XCTAssertEqual(gameService.currentState, GameState.running)
    }

    func testOneHorizontalMovementStraight() throws {
        startGame(randomTetromino: 1)
        checkMovement()
    }
    
    func testOneHorizontalMovementSquare() throws {
        startGame(randomTetromino: 2)
        checkMovement()
    }
    
    func testOneHorizontalMovementT() throws {
        startGame(randomTetromino: 3)
        checkMovement()
    }
    
    func testOneHorizontalMovementL() throws {
        startGame(randomTetromino: 4)
        checkMovement()
    }
    
    func testOneHorizontalMovementSkew() throws {
        startGame(randomTetromino: 5)
        checkMovement()
    }
    
    func checkMovement(){
        let startingTetrominoColumn = gameService.currentTetromino!.squares.firstSquare.boardColumn
        XCTAssertTrue(gameService!.moveLeft())
        let movedTetrominoColumn = gameService.currentTetromino!.squares.firstSquare.boardColumn
        XCTAssertEqual(startingTetrominoColumn, movedTetrominoColumn + 1)
    }
    
    func testTimerTickMakesTetrominoGoDown() throws{
        startGame()
        let startingTetrominoRow = gameService.currentTetromino!.squares.firstSquare.boardRow
        timerService.forceTimerTick()
        let movedTetrominoRow = gameService.currentTetromino!.squares.firstSquare.boardRow
        XCTAssertEqual(startingTetrominoRow + 1, movedTetrominoRow)
    }
    
    func testNewTetrominoInBoard() throws {
        startGame()
        moveAllWayDown()
        XCTAssertFalse(gameService!.currentTetromino?.squares.firstSquare.boardRow == 0)
        timerService.forceTimerTick()
        XCTAssertTrue(gameService!.currentTetromino?.squares.firstSquare.boardRow == 0)
    }
    
    func moveAllWayDown(){
        while gameService!.moveDown() {}
    }
    
    func testGameOver() throws {
        startGame()
        while gameService.currentState != .stopped{
            moveAllWayDown()
            timerService.forceTimerTick()
        }
        XCTAssertEqual(gameService.currentState, .stopped)
    }

}
