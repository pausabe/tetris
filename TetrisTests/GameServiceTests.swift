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
    var tetrominoHelperMock: TetrominoHelperMock! = nil
    var timerService: TimerServiceMock! = nil
    let rows = 20
    let columns = 10
    
    override func setUp() {
        tetrominoHelperMock = TetrominoHelperMock()
        timerService = TimerServiceMock()
        let boardServie = BoardService()
        boardServie.initBoardMap(rows: rows, columns: columns)
        gameService = GameService(
            timerService: timerService,
            boardService: boardServie,
            tetrominoService: tetrominoHelperMock)
    }
    
    func testStartGame() throws {
        startGame()
    }
    
    func startGame(randomTetromino: Int? = nil) {
        XCTAssertEqual(gameService.currentState, GameState.stopped)
        XCTAssertNil(gameService.currentTetromino)
        
        tetrominoHelperMock.randomTetromino = randomTetromino
        gameService!.startGame()
        
        XCTAssertNotNil(gameService.currentTetromino)
        XCTAssertEqual(gameService.currentState, GameState.running)
    }

    func testOneHorizontalMovementStraight() throws {
        startGame(randomTetromino: 1)
        checkMovement()
    }
    
    func checkMovement(){
        let startingTetrominoColumn = gameService.currentTetromino!.squares.firstSquare.column
        XCTAssertTrue(gameService!.moveLeft())
        let movedTetrominoColumn = gameService.currentTetromino!.squares.firstSquare.column
        XCTAssertEqual(startingTetrominoColumn, movedTetrominoColumn + 1)
    }
    
    func testTimerTickMakesTetrominoGoDown() throws{
        startGame()
        let startingTetrominoRow = gameService.currentTetromino!.squares.firstSquare.row
        timerService.forceTimerTick()
        let movedTetrominoRow = gameService.currentTetromino!.squares.firstSquare.row
        XCTAssertEqual(startingTetrominoRow + 1, movedTetrominoRow)
    }
    
    func testNewTetrominoInBoard() throws {
        startGame(randomTetromino: 1)
        moveAllWayDown()
        XCTAssertFalse(gameService!.currentTetromino?.squares.firstSquare.row == 0)
        timerService.forceTimerTick()
        XCTAssertTrue(gameService!.currentTetromino?.squares.firstSquare.row == 0)
    }
    
    func moveAllWayDown(){
        while gameService!.moveDown() {}
    }
    
    func testGameOver() throws {
        startGame(randomTetromino: 6)
        while gameService.currentState != .stopped{
            moveAllWayDown()
            timerService.forceTimerTick()
        }
        XCTAssertEqual(gameService.currentState, .stopped)
    }
    
    func testFullRow() throws{
        startGame(randomTetromino: 7)
        XCTAssertEqual(gameService.currentScore, 0)
        let maximumTetrominoSquare = columns / 2
        for i in 1...maximumTetrominoSquare {
            moveTetrominoToMaximumBottomLeft()
            if i == maximumTetrominoSquare{
            }
            timerService.forceTimerTick()
        }
        XCTAssertEqual(gameService.currentScore, maximumTetrominoSquare * 4)
    }
    
    func moveTetrominoToMaximumBottomLeft(){
        while gameService!.moveRight() {}
        while gameService!.moveDown() {}
        while gameService!.moveLeft() {}
    }
    
}
