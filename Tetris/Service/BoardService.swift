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
    
    init(rows: Int,
         columns: Int){
        initBoardMap(rows: rows, columns: columns)
        setTetrominoStartPosition()
    }
    
    func initBoardMap(rows: Int,
                      columns: Int){
        board = Board(rows: rows,
                      columns: columns)
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
    
    func updateTetrominoSquares(tetromino: Tetromino, boardPositionFill: UIColor?){
        board!.map[tetromino.squares.firstSquare.boardRow][tetromino.squares.firstSquare.boardColumn] = boardPositionFill
        board!.map[tetromino.squares.secondSquare.boardRow][tetromino.squares.secondSquare.boardColumn] = boardPositionFill
        board!.map[tetromino.squares.thirdSquare.boardRow][tetromino.squares.thirdSquare.boardColumn] = boardPositionFill
        board!.map[tetromino.squares.fourthSquare.boardRow][tetromino.squares.fourthSquare.boardColumn] = boardPositionFill
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
        let oldFirstSquare = tetromino.squares.firstSquare
        clearTetrominoInBoard(tetromino: tetromino)
        tetromino.setSquaresByFirstSquare(firstSquareRow: newStartingTetrominoRow, firstSquareColumn: newStartingTetrominoColumn)
        
        let movementIsPossible = tetrominoIsInCorrectPlace(tetromino: tetromino)
        
        tetromino.setSquaresByFirstSquare(firstSquareRow: oldFirstSquare.boardRow, firstSquareColumn: oldFirstSquare.boardColumn)
        setTetrominoInBoard(tetromino: tetromino)
        
        return movementIsPossible
    }
    
    func tetrominoIsInCorrectPlace(tetromino: Tetromino) -> Bool {
        if !tetrominoSquareIsAvailable(square: tetromino.squares.firstSquare){
            return false
        }
        if !tetrominoSquareIsAvailable(square: tetromino.squares.secondSquare) {
            return false
        }
        if !tetrominoSquareIsAvailable(square: tetromino.squares.thirdSquare){
            return false
        }
        if !tetrominoSquareIsAvailable(square: tetromino.squares.fourthSquare){
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
