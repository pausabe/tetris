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
    private var currentIntervalSeconds: Double = 0
    private let minIntervalSeconds: Double = 0.1
    
    func start(intervalSeconds: Double) {
        timer?.invalidate()
        currentIntervalSeconds = intervalSeconds
        timer = Timer.scheduledTimer(timeInterval: intervalSeconds, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
    }
    
    func stop() {
        timer?.invalidate()
    }
    
    @objc
    private func timerTick(){
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
