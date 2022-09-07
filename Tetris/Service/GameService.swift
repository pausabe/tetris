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

public class GameService : GameServiceProtocol, TimerServiceDelegate {
    var timerService: TimerServiceProtocol! = nil
    var boardService: BoardServiceProtocol! = nil
    
    var timeTickIntervalSeconds: Double = 1.5
    var currentTetromino: Tetromino?
    var currentState = GameState.stopped
    enum movementDirections{
        case left, right, down
    }
    
    init(timerService: TimerServiceProtocol? = nil, boardService: BoardServiceProtocol? = nil){
        self.timerService = timerService ?? ServiceLocator.shared.getService()! as TimerServiceProtocol
        self.boardService = boardService ?? ServiceLocator.shared.getService()! as BoardServiceProtocol
        
        self.timerService?.delegate = self
    }

    func play() {
        if currentState == GameState.stopped{
            currentTetromino = newRandomTetromino()
            moveCurrentTetrominoToStartPosition()
        }
        
        currentState = GameState.running
        timerService.start(intervalSeconds: timeTickIntervalSeconds)
    }
    
    func newRandomTetromino() -> Tetromino{
        // TODO: also we should determine the rotation randomly
        switch(Int.random(in: 1...5)){
            case 1:
                return StraightTetromino()
            case 2:
                return SquareTetromino()
            case 3:
                return TTetromino()
            case 4:
                return LTetromino()
            case 5:
                return SkewTetromino()
            default:
                return StraightTetromino()
            }
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
    
    func timerTick() {
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
    
    func move(direction: movementDirections) -> Bool{
        if currentTetromino != nil{
            let newRow = currentTetromino!.firstSquare.boardRow + (direction == .down ? 1 : 0)
            var newColumn = currentTetromino!.firstSquare.boardColumn
            if direction == .left{
                newColumn -= 1
            }
            else if direction == .right{
                newColumn += 1
            }
            return boardService.moveTetromino(
                tetromino: currentTetromino!,
                newStartingTetrominoRow: newRow,
                newStartingTetrominoColumn: newColumn)
        }
        return false
    }
}
