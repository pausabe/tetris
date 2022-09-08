//
//  StepsService.swift
//  Tetris
//
//  Created by Pau Sabé Martínez on 5/9/22.
//

import Foundation

enum GameState {
    case stopped, running, paused
}

protocol GameServiceDelegate{
    func tetrominoHasMoved()
}

public class GameService : GameServiceProtocol, TimerServiceDelegate {
    
    var timerService: TimerServiceProtocol! = nil
    var boardService: BoardServiceProtocol! = nil
    var tetrominoService: TetrominoServiceProtocol! = nil
    
    var delegate: GameServiceDelegate?
    var timeTickIntervalSeconds: Double = 1.5
    var currentTetromino: Tetromino?
    var currentState = GameState.stopped
    enum movementDirections{
        case left, right, down
    }
    
    init(timerService: TimerServiceProtocol? = nil,
         boardService: BoardServiceProtocol? = nil,
         tetrominoService: TetrominoServiceProtocol? = nil){
        self.timerService = timerService ?? ServiceLocator.shared.getService()! as TimerServiceProtocol
        self.boardService = boardService ?? ServiceLocator.shared.getService()! as BoardServiceProtocol
        self.tetrominoService = tetrominoService ?? ServiceLocator.shared.getService()! as TetrominoServiceProtocol
        
        self.timerService?.delegate = self
    }

    func play() {
        if currentState == GameState.stopped{
            currentTetromino = tetrominoService.newRandomTetromino()
            moveCurrentTetrominoToStartPosition()
        }
        
        currentState = GameState.running
        timerService.start(intervalSeconds: timeTickIntervalSeconds)
    }
    
    func moveCurrentTetrominoToStartPosition(){
        if currentTetromino != nil{
            currentTetromino?.setSquaresByFirstSquare(
                firstSquareRow: boardService.tetrominoStartingRow,
                firstSquareColumn: boardService.tetrominoStartingColumn)
            
            boardService.setTetrominoInBoard(tetromino: currentTetromino!)
        }
    }
    
    func pause(){
        // TODO:
        currentState = GameState.paused
        timerService.stop()
    }
    
    func stop(){
        // TODO:
        currentState = GameState.stopped
        timerService.stop()
    }
    
    func getBoardRows() -> Int {
        boardService.board!.rowNumber
    }
    
    func getBoardColumns() -> Int {
        boardService.board!.columnNumber
    }
    
    func timerTick() {
        move(direction: .down)
        /*
         TODO:
         
         GameService.MoveDown() // Same as move left
         
         var currentGameState = GameService.EvaluateBoardState()
         if currentGameState == GameState.Over {
            print all necessary to intorm user that the game is over
         }
         else{
            redraw all board (maybe this its not always necessary...)
         }
         
         // What EvaluateBoard does:
         - Check if there is a row that can be deleted (checking at GameService.RowCompleted). And in case of a row deltion:
            - Remove row from the GameService.BoardMap moving all the Tetronimos avobe the row
            - Prepare the new current Tetronimo
         - In case of not row deletion, check if position is at bottom. And in case of reached the bottom:
            - Prepare the new current Tetronimo
         - Check if its actually a game over (when we wanted to prepare the new current Tetronimo but it wasant possible to fit it) and updates the GameService.
         - Return the GameService.GameState
         
         */
    }
    
    func moveLeft() -> Bool {
        return move(direction: .left)
    }
    
    func moveRight() -> Bool{
        return move(direction: .right)
    }
    
    @discardableResult func move(direction: movementDirections) -> Bool{
        if currentTetromino != nil{
            let newRow = currentTetromino!.squares.firstSquare.boardRow + (direction == .down ? 1 : 0)
            var newColumn = currentTetromino!.squares.firstSquare.boardColumn
            if direction == .left{
                newColumn -= 1
            }
            else if direction == .right{
                newColumn += 1
            }
            if boardService.moveTetromino(
                tetromino: currentTetromino!,
                newStartingTetrominoRow: newRow,
                newStartingTetrominoColumn: newColumn){
                
                currentTetromino?.setSquaresByFirstSquare(firstSquareRow: newRow, firstSquareColumn: newColumn)
                delegate?.tetrominoHasMoved()
                return true
            }
        }
        return false
    }
}
