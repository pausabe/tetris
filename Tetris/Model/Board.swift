//
//  Board.swift
//  Tetris
//
//  Created by Pau Sabé Martínez on 5/9/22.
//

import Foundation
import SwiftUI

struct Board{
    var rowNumber = 0
    var columnNumber = 0
    var map = [[UIColor?]]()
    
    init(rows: Int,
         columns: Int){
        rowNumber = rows
        columnNumber = columns
        map = Array(repeating: Array(repeating: nil, count: columnNumber), count: rows)
    }
}
