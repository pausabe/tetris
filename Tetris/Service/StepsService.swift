//
//  StepsService.swift
//  Tetris
//
//  Created by Pau Sabé Martínez on 5/9/22.
//

import Foundation

class StepsService : StepsServiceProtocol {

    static let shared = StepsService()
    private init(){}
    
    var horizontalStep: Int = 30
    var verticalStep: Int = 40
    var startingPositionX: Int = 15
    var startingPositionY: Int = 15
    
    private var speedStep = 1
    
    func increaseSpeed() {
        verticalStep += speedStep
    }
    
}
