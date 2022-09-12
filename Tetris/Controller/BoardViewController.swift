//
//  BoardViewController.swift
//  Tetris
//
//  Created by Pau Sabé Martínez on 12/9/22.
//

import SwiftUI

class BoardViewController: UIViewController{
    
    var gameService : GameServiceProtocol! = nil
    
    var boardPositionAndSubviewRelation: [String: UIView] = [:]
    var lastTetrominoPosition: TetrominoSquares?
    var squareSize: Float = 0
    var rowNumber: Int = 0
    var columnNumber: Int = 0
    var playableBoardView: UIView!
    
    override func viewDidAppear(_ animated: Bool) {
        loadDependencies()
        defineBoard()
    }
    
    // ViewControllers does not have init() constructor. We let accessible this method to load the dependencies as desired
    public func loadDependencies(mediaPlayerService : MediaPlayerServiceProtocol? = nil,
                                 gameService : GameServiceProtocol? = nil){
        self.gameService = gameService ?? ServiceLocator.shared.getService()! as GameServiceProtocol
    }
    
    func defineBoard(){
        let startingSquareSize: Float = 20
        
        let gameHeight: Float = Float(self.view.frame.size.height)
        let gameWidth: Float = Float(self.view.frame.size.width)
        
        let maximumRows = Int(floor(gameHeight / startingSquareSize))
        squareSize = Float(gameHeight) / Float(maximumRows)
        rowNumber = Int(floor(gameHeight / squareSize))
        columnNumber = Int(floor(gameWidth / squareSize))
        
        let boardWidth = Float(columnNumber) * squareSize
        let xOffsetToCenterBoard: Float = (gameWidth - boardWidth) / 2
        
        let viewRectFrame = CGRect(x: CGFloat(xOffsetToCenterBoard), y: CGFloat(0), width: CGFloat(boardWidth), height: CGFloat(Float(rowNumber) * squareSize))
        playableBoardView = UIView(frame: viewRectFrame)
        // TODO: move color somwhere else
        playableBoardView.backgroundColor = UIColor(#colorLiteral(red: 0.07213427871, green: 0.1938643456, blue: 0.2723750472, alpha: 0.8))
        
        self.view.addSubview(playableBoardView)
        gameService.initGame(rows: rowNumber, columns: columnNumber)
    }
    
    func startGame(){
        lastTetrominoPosition = gameService.currentTetromino!.squares
        drawTetromino(gameService!.currentTetromino!)
    }
    
    func eraseCurrentTetrominoLastPosition(){
        if lastTetrominoPosition != nil{
            eraseSquare(lastTetrominoPosition!.firstSquare)
            eraseSquare(lastTetrominoPosition!.secondSquare)
            eraseSquare(lastTetrominoPosition!.thirdSquare)
            eraseSquare(lastTetrominoPosition!.fourthSquare)
        }
    }
    
    func eraseSquare(_ square: Square){
        let squareView = boardPositionAndSubviewRelation[squareKey(square)]
        squareView?.removeFromSuperview()
    }
    
    func drawTetromino(_ tetromino: Tetromino){
        drawSquare(tetromino.squares.firstSquare, gameService.currentTetromino!.color)
        drawSquare(tetromino.squares.secondSquare, gameService.currentTetromino!.color)
        drawSquare(tetromino.squares.thirdSquare, gameService.currentTetromino!.color)
        drawSquare(tetromino.squares.fourthSquare, gameService.currentTetromino!.color)
    }
    
    func drawSquare(_ square: Square, _ color: UIColor){
        let squareView : UIView = createSquare(
            x: Float(square.column) * squareSize,
            y: Float(square.row) * squareSize,
            color: color)
        
        /*let squareView : UIView = UIImageView(image: UIImage(named: "launch_icon"))
        squareView.frame = CGRect(x: CGFloat(Float(square.boardColumn) * squareSize), y: CGFloat(Float(square.boardRow) * squareSize), width: CGFloat(squareSize), height: CGFloat(squareSize))*/
        
        playableBoardView.addSubview(squareView)
        boardPositionAndSubviewRelation[squareKey(square)] = squareView
    }
    
    func squareKey(_ square: Square) -> String{
        return "\(square.row)_\(square.column)"
    }
    
    func createSquare(x: Float, y: Float, color: UIColor) -> UIView{
        let viewRectFrame = CGRect(x: CGFloat(x), y: CGFloat(y), width: CGFloat(squareSize), height: CGFloat(squareSize))
        let retView = UIView(frame: viewRectFrame)
        retView.backgroundColor = color
        retView.alpha = CGFloat(1.0)
        return retView
    }
    
    func drawEntireBoard(){
        for rowIndex in 0...(rowNumber - 1){
            for columnIndex in (0...columnNumber - 1){
                var square = Square()
                square.row = rowIndex
                square.column = columnIndex
                eraseSquare(square)
                let color: UIColor? = gameService.getColorOfSquare(square)
                if color != nil{
                    drawSquare(square, color!)
                }
            }
        }
    }
    
    func drawTetrominoMovement(){
        eraseCurrentTetrominoLastPosition()
        drawTetromino(gameService!.currentTetromino!)
        lastTetrominoPosition = gameService!.currentTetromino!.squares
    }
    
    func drawNewTetrominoAdded(){
        drawTetromino(gameService!.currentTetromino!)
        lastTetrominoPosition = gameService!.currentTetromino!.squares
    }
    
}
