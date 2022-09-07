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
    
    func clearTetrominoInBoard(tetromino: Tetromino){
        updateTetrominoSquares(tetromino: tetromino, boardPositionFill: nil)
    }
    
    func setTetrominoInBoard(tetromino: Tetromino) {
        updateTetrominoSquares(tetromino: tetromino, boardPositionFill: tetromino.color)
    }
    
    func updateTetrominoSquares(tetromino: Tetromino, boardPositionFill: Color?){
        board!.map[tetromino.firstSquare.boardRow][tetromino.firstSquare.boardColumn] = boardPositionFill
        board!.map[tetromino.secondSquare.boardRow][tetromino.secondSquare.boardColumn] = boardPositionFill
        board!.map[tetromino.thirdSquare.boardRow][tetromino.thirdSquare.boardColumn] = boardPositionFill
        board!.map[tetromino.fourthSquare.boardRow][tetromino.fourthSquare.boardColumn] = boardPositionFill
    }
    
    func moveTetromino(tetromino: Tetromino, newStartingTetrominoRow: Int, newStartingTetrominoColumn: Int) -> Bool{
        if checkMovementPossibility(tetromino: tetromino, newStartingTetrominoRow: newStartingTetrominoRow, newStartingTetrominoColumn: newStartingTetrominoColumn){
            
            clearTetrominoInBoard(tetromino: tetromino)
            tetromino.setSquaresByFirstSquare(
                firstSquareRow: newStartingTetrominoRow,
                firstSquareColumn: newStartingTetrominoColumn)
            setTetrominoInBoard(tetromino: tetromino)
            // TODO: Check if with this movement there is some Row completed and it saves it into GameService.RowCompleted array
            return true
        }
        return false
    }
    
    func checkMovementPossibility(tetromino: Tetromino, newStartingTetrominoRow: Int, newStartingTetrominoColumn: Int) -> Bool{
        let oldFirstSquare = tetromino.firstSquare
        tetromino.setSquaresByFirstSquare(firstSquareRow: newStartingTetrominoRow, firstSquareColumn: newStartingTetrominoColumn)
        
        clearTetrominoInBoard(tetromino: tetromino)
        let movementIsPossible = tetrominoIsInCorrectPlace(tetromino: tetromino)
        
        tetromino.setSquaresByFirstSquare(firstSquareRow: oldFirstSquare.boardRow, firstSquareColumn: oldFirstSquare.boardColumn)
        setTetrominoInBoard(tetromino: tetromino)
        
        return movementIsPossible
    }
    
    func tetrominoIsInCorrectPlace(tetromino: Tetromino) -> Bool {
        if !tetrominoSquareIsAvailable(square: tetromino.firstSquare){
            return false
        }
        if !tetrominoSquareIsAvailable(square: tetromino.secondSquare) {
            return false
        }
        if !tetrominoSquareIsAvailable(square: tetromino.thirdSquare){
            return false
        }
        if !tetrominoSquareIsAvailable(square: tetromino.fourthSquare){
            return false
        }
        return true
    }
    
    func tetrominoSquareIsAvailable(square: Square) -> Bool {
         if square.boardRow < 0 || square.boardColumn < 0 {
            return false
        }
        if square.boardRow > (board!.rowNumber - 1) || square.boardColumn > (board!.columnNumber - 1){
            return false
        }
        if board!.map[square.boardRow][square.boardColumn] != nil {
            return false
        }
        return true
    }
    
}
