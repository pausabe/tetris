//
//  StepsService.swift
//  Tetris
//
//  Created by Pau Sabé Martínez on 5/9/22.
//

import Foundation
import UIKit

enum GameState {
    case stopped, running
}

protocol GameServiceDelegate{
    func tetrominoHasMoved()
    func newTetrominoAdded()
    func fullRowCleared()
    func gameOver()
}

public class GameService : GameServiceProtocol, TimerServiceDelegate {
    
    private var timerService: TimerServiceProtocol! = nil
    private var boardService: BoardServiceProtocol! = nil
    private var tetrominoHelper: TetrominoHelperProtocol! = nil
    
    var delegate: GameServiceDelegate?
    private var startingTimerIntervalSeconds: Double = 1.5
    private var incrementTimerSeconds: Double = 0.01
    var nextTetromino: Tetromino?
    var currentTetromino: Tetromino?
    var currentState = GameState.stopped
    var currentScore: Int = 0
    
    init(timerService: TimerServiceProtocol? = nil,
         boardService: BoardServiceProtocol? = nil,
         tetrominoService: TetrominoHelperProtocol? = nil){
        self.timerService = timerService ?? ServiceLocator.shared.getService()! as TimerServiceProtocol
        self.boardService = boardService ?? ServiceLocator.shared.getService()! as BoardServiceProtocol
        self.tetrominoHelper = tetrominoService ?? ServiceLocator.shared.getService()! as TetrominoHelperProtocol
        
        self.timerService?.delegate = self
    }
    
    func initGame(rows: Int, columns: Int) {
        boardService.initBoardMap(rows: rows, columns: columns)
    }

    func startGame() {
        if currentState == GameState.stopped{
            nextTetromino = tetrominoHelper.newRandomTetromino(boardService.tetrominoStartingRow, boardService.tetrominoStartingColumn)
            startNewTetromino()
            currentState = GameState.running
            currentScore = 0
            timerService.start(intervalSeconds: startingTimerIntervalSeconds)
        }
    }
    
    @discardableResult
    private func startNewTetromino() -> Bool{
        currentTetromino = nextTetromino
        nextTetromino = tetrominoHelper.newRandomTetromino(boardService.tetrominoStartingRow, boardService.tetrominoStartingColumn)
        return boardService.setNewTetrominoInBoard(squares: currentTetromino!.squares, color: currentTetromino?.color)
    }
    
    private func getBoardRows() -> Int {
        boardService.board!.rowNumber
    }
    
    private func getBoardColumns() -> Int {
        boardService.board!.columnNumber
    }
    
    func getColorOfSquare(_ square: Square) -> UIColor? {
        return boardService.board!.map[square.row][square.column]
    }
    
    func timerTick() {
        if !move(.down){
            let rowsCleared = boardService.clearFullRows(currentTetromino!.squares)
            if rowsCleared > 0 {
                currentScore += (rowsCleared * boardService.board!.columnNumber)
                delegate?.fullRowCleared()
            }
            startNewTetromino() ? setNewTetromino() : setGameOver()
        }
    }
    
    private func setNewTetromino(){
        timerService.incrementSpeed(incrementTimerSeconds)
        delegate?.newTetrominoAdded()
    }
    
    private func setGameOver(){
        timerService.stop()
        boardService.clearBoard()
        currentState = .stopped
        delegate?.gameOver()
    }
    
    func moveLeft() -> Bool {
        return move(.left)
    }
    
    func moveRight() -> Bool{
        return move(.right)
    }
    
    func moveDown() -> Bool{
        return move(.down)
    }
    
    func rotate() -> Bool {
        return move(.rotation)
    }
    
    @discardableResult
    private func move(_ direction: MovementDirectionEnum) -> Bool{
        if currentState == .running && boardService.moveTetromino(
            original: currentTetromino!.squares,
            desired: currentTetromino!.getDesiredSquares(direction),
            color: currentTetromino?.color){
            
            currentTetromino!.move(direction)
            delegate?.tetrominoHasMoved()
            return true
        }
        return false
    }
    
}
