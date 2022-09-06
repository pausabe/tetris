//
//  BoardService.swift
//  Tetris
//
//  Created by Pau Sabé Martínez on 6/9/22.
//

import Foundation
import SwiftUI

class BoardService : BoardServiceProtocol{
    
    var board: Board?
    var tetrominoStartingColumn: Int = 0
    var tetrominoStartingRow: Int = 0
    
    init(){
        initBoardMap()
        setTetrominoStartPosition()
    }
    
    func initBoardMap(){
        board = Board()
        board!.map = Array(repeating: Array(repeating: nil, count: board!.columnNumber), count: board!.rowNumber)
    }
    
    func setTetrominoStartPosition(){
        tetrominoStartingRow = 0
        tetrominoStartingColumn = Int(floor(Double(board!.columnNumber / 2)))
    }
    
    func setTetrominoInBoard(tetromino: Tetrominio) {
        board!.map[tetromino.firstSquare.boardRow][tetromino.firstSquare.boardColumn] = tetromino.color
        board!.map[tetromino.secondSquare.boardRow][tetromino.secondSquare.boardColumn] = tetromino.color
        board!.map[tetromino.thirdSquare.boardRow][tetromino.thirdSquare.boardColumn] = tetromino.color
        board!.map[tetromino.fourthSquare.boardRow][tetromino.fourthSquare.boardColumn] = tetromino.color
    }
}
