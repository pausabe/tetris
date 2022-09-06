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
    
    func start(intervalSeconds: Double) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: intervalSeconds, target:self, selector: #selector(timerTick), userInfo: nil, repeats: true)
    }
    
    func stop() {
        timer?.invalidate()
    }
    
    @objc func timerTick(){
        delegate?.timerTick()
    }

}
