//
//  TetrisTests.swift
//  TetrisTests
//
//  Created by Pau Sabé Martínez on 6/9/22.
//

import XCTest
@testable import Tetris

class GameServiceTests: XCTestCase {
    
    /*
     XCTAssertNotNil asserts a variable is not nil.
     XCTAssertTrue asserts a condition is true.
     XCTAssertFalse asserts a condition is false.
     XCTAssertEqual asserts two values are equal.
     
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }*/
    
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
    }

}
