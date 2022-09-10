//
//  TimerService.swift
//  Tetris
//
//  Created by Pau Sabé Martínez on 6/9/22.
//

import Foundation

protocol TimerServiceDelegate{
    func timerTick()
}

class TimerService : TimerServiceProtocol{
    var delegate: TimerServiceDelegate?
    var timer: Timer?
    var currentIntervalSeconds: Double = 0
    let minIntervalSeconds: Double = 0.1
    
    func start(intervalSeconds: Double) {
        timer?.invalidate()
        currentIntervalSeconds = intervalSeconds
        timer = Timer.scheduledTimer(timeInterval: intervalSeconds, target:self, selector: #selector(timerTick), userInfo: nil, repeats: true)
    }
    
    func stop() {
        timer?.invalidate()
    }
    
    @objc func timerTick(){
        delegate?.timerTick()
    }
    
    func incrementSpeed(_ incrementSeconds: Double) {
        var newInterval = currentIntervalSeconds - incrementSeconds
        if newInterval < minIntervalSeconds {
            newInterval = minIntervalSeconds
        }
        start(intervalSeconds: newInterval)
    }

}
