//
//  TimerServiceProtocol.swift
//  Tetris
//
//  Created by Pau Sabé Martínez on 6/9/22.
//

import Foundation

protocol TimerServiceProtocol{
    var delegate: TimerServiceDelegate? { get set }
    var timer: Timer? { get }
    
    func start(intervalSeconds: Double)
    func stop()
}
