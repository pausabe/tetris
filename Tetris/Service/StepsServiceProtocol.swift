//
//  StepsServiceProtocol.swift
//  Tetris
//
//  Created by Pau Sabé Martínez on 5/9/22.
//

import Foundation

protocol StepsServiceProtocol{
    var horizontalStep: Int { get }
    var verticalStep: Int { get }
    var startingPositionX: Int { get }
    var startingPositionY: Int { get }
    
    func increaseSpeed()
}
