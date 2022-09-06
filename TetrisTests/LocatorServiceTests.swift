//
//  LocatorServiceTests.swift
//  TetrisTests
//
//  Created by Pau Sabé Martínez on 6/9/22.
//

import XCTest
@testable import Tetris

class LocatorServiceTests: XCTestCase {

    func testOneService() {
        let mediaPlayerService = MediaPlayerService()
        ServiceLocator.shared.addService(service: mediaPlayerService)
        XCTAssertEqual(mediaPlayerService.test, "default")
    }
    
    func testMoreThanOneServices() {
        let mediaPlayerService = MediaPlayerService()
        ServiceLocator.shared.addService(service: mediaPlayerService)
        let gameService = GameService()
        ServiceLocator.shared.addService(service: gameService)
        XCTAssertEqual(mediaPlayerService.test, "default")
        XCTAssertEqual(gameService.horizontalStep, 30)
    }
    
    func testAlwaysSameInstance(){
        let mediaPlayerService = MediaPlayerService()
        ServiceLocator.shared.addService(service: mediaPlayerService)
        let mediaPlayerServiceFromLocator: MediaPlayerServiceProtocol = ServiceLocator.shared.getService()!
        
        mediaPlayerService.test = "test changed"
        
        XCTAssertEqual(mediaPlayerServiceFromLocator.test, "test changed")
        
    }

}
