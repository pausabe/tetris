//
//  TimerServiceMock.swift
//  TetrisTests
//
//  Created by Pau Sabé Martínez on 8/9/22.
//

import Foundation
@testable import Tetris

class TimerServiceMock : TimerServiceProtocol{
    var delegate: TimerServiceDelegate?
    
    var timer: Timer?
    
    func start(intervalSeconds: Double) {
    }
    
    func stop() {
    }
    
    func forceTimerTick(){
        delegate?.timerTick()
    }
    
    func incrementSpeed(_ incrementSeconds: Double) {
        
    }
}
