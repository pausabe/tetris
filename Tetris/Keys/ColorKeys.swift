//
//  ColorKeys.swift
//  Tetris
//
//  Created by Pau Sabé Martínez on 13/9/22.
//

import Foundation
import SwiftUI

class ColorKeys{
    static var LTetromino: UInt32 = 0xa480cf
    static var LTetrominoInverted: UInt32 = 0xc5f6fb
    static var skewTetromino: UInt32 = 0xff8877
    static var skewTetrominoInverted: UInt32 = 0xffff82
    static var TTetromino: UInt32 = 0x6cccda
    static var straightTetromino: UInt32 = 0xb3e2a6
    static var squareTetromino: UInt32 = 0xffd670
    static var playableBoardBackground = UIColor(Color.white.opacity(0.25))
}
