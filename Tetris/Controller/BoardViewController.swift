//
//  BoardViewController.swift
//  Tetris
//
//  Created by Pau Sabé Martínez on 12/9/22.
//

import SwiftUI

class BoardViewController: UIViewController{
    
    private var gameService : GameServiceProtocol! = nil
    
    private var boardPositionAndSubviewRelation: [String: UIView] = [:]
    private var lastTetrominoPosition: TetrominoSquares?
    private var squareSize: Float = 0
    private var rowNumber: Int = 0
    private var columnNumber: Int = 0
    private var playableBoardView: UIView!
    
    override func viewDidAppear(_ animated: Bool) {
        loadDependencies()
        defineBoard()
        drawBoardGrid()
    }
    
    // ViewControllers does not have init() constructor. We let accessible this method to load the dependencies as desired
    public func loadDependencies(mediaPlayerService : MediaPlayerServiceProtocol? = nil,
                                 gameService : GameServiceProtocol? = nil){
        self.gameService = gameService ?? ServiceLocator.shared.getService()! as GameServiceProtocol
    }
    
    private func defineBoard(){
        let startingSquareSize: Float = 28
        
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
        playableBoardView.backgroundColor = ColorKeys.playableBoardBackground
        
        self.view.addSubview(playableBoardView)
        gameService.initGame(rows: rowNumber, columns: columnNumber)
    }
    
    private func drawBoardGrid(){
        let gridView: GridView = GridView()
        gridView.frame = playableBoardView.bounds
        playableBoardView.addSubview(gridView)
        gridView.drawGrid(gridWidth: CGFloat(squareSize), color: .white, lineWidth: CGFloat(TetrominoDrawer.squarePadding))
    }
    
    func startBoard(){
        lastTetrominoPosition = gameService.currentTetromino!.squares
        drawTetromino(gameService!.currentTetromino!)
    }
    
    func clearBoard(){
        for squareView in boardPositionAndSubviewRelation{
            squareView.value.removeFromSuperview()
        }
        boardPositionAndSubviewRelation.removeAll()
    }
    
    private func eraseCurrentTetrominoLastPosition(){
        if lastTetrominoPosition != nil{
            eraseSquare(lastTetrominoPosition!.firstSquare)
            eraseSquare(lastTetrominoPosition!.secondSquare)
            eraseSquare(lastTetrominoPosition!.thirdSquare)
            eraseSquare(lastTetrominoPosition!.fourthSquare)
        }
    }
    
    private func eraseSquare(_ square: Square){
        let squareViewKey = squareKey(square)
        let squareView = boardPositionAndSubviewRelation[squareViewKey]
        boardPositionAndSubviewRelation.removeValue(forKey: squareViewKey)
        squareView?.removeFromSuperview()
    }
    
    private func drawTetromino(_ tetromino: Tetromino){
        drawSquare(tetromino.squares.firstSquare, gameService.currentTetromino!.color)
        drawSquare(tetromino.squares.secondSquare, gameService.currentTetromino!.color)
        drawSquare(tetromino.squares.thirdSquare, gameService.currentTetromino!.color)
        drawSquare(tetromino.squares.fourthSquare, gameService.currentTetromino!.color)
    }
    
    private func drawSquare(_ square: Square, _ color: UIColor){
        let squareView = TetrominoDrawer.generateSquareView(
            x: (Float(square.column) * squareSize),
            y: (Float(square.row) * squareSize),
            squareSize: squareSize,
            color: color)
        
        playableBoardView.addSubview(squareView)
        boardPositionAndSubviewRelation[squareKey(square)] = squareView
    }
    
    private func squareKey(_ square: Square) -> String{
        return "\(square.row)_\(square.column)"
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
