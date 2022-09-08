//
//  ViewController.swift
//  Tetris
//
//  Created by Pau Sabé Martínez on 31/8/22.
//

import UIKit
import SwiftUI

class MainViewController: UIViewController, GameServiceDelegate {
    
    var mediaPlayerService : MediaPlayerServiceProtocol! = nil
    var gameService : GameServiceProtocol! = nil
    
    var boardPositionAndSubviewRelation: [String: UIView] = [:]
    var lastTetrominoPosition: TetrominoSquares?
    let rightSpaceForInformation: Float = 100.0
    var squareSize: Float = 0
    var rowNumber: Int = 0
    var columnNumber: Int = 0
    var boardView: UIView!
    
    @IBOutlet weak var gameView: UIView!
    
    override func viewDidAppear(_ animated: Bool) {
        defineBoard()
        addServicesToLocator()
        loadDependencies()
    }
    
    func addServicesToLocator(){
        ServiceLocator.shared.addService(service: TimerService())
        ServiceLocator.shared.addService(service: BoardService(rows: rowNumber, columns: columnNumber))
        ServiceLocator.shared.addService(service: TetrominoService())
        ServiceLocator.shared.addService(service: MediaPlayerService())
        ServiceLocator.shared.addService(service: GameService())
    }
    
    // ViewControllers does not have init() constructor. We let accessible this method to load the dependencies as desired
    public func loadDependencies(mediaPlayerService : MediaPlayerServiceProtocol? = nil,
                                 gameService : GameServiceProtocol? = nil){
        self.mediaPlayerService = mediaPlayerService ?? ServiceLocator.shared.getService()! as MediaPlayerServiceProtocol
        self.gameService = gameService ?? ServiceLocator.shared.getService()! as GameServiceProtocol
        self.gameService.delegate = self
    }
    
    func defineBoard(){
        let startingSquareSize: Float = 20
        
        let gameHeight: Float = Float(gameView.frame.size.height)
        let gameWidth: Float = Float(gameView.frame.size.width) - rightSpaceForInformation
        
        let maximumRows = Int(floor(gameHeight / startingSquareSize))
        squareSize = Float(gameHeight) / Float(maximumRows)
        rowNumber = Int(floor(gameHeight / squareSize))
        columnNumber = Int(floor(gameWidth / squareSize))
        
        let viewRectFrame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(Float(columnNumber) * squareSize), height: CGFloat(Float(rowNumber) * squareSize))
        boardView = UIView(frame: viewRectFrame)
        boardView.backgroundColor = UIColor(#colorLiteral(red: 0.07213427871, green: 0.1938643456, blue: 0.2723750472, alpha: 0.8))
        
        gameView.addSubview(boardView)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        gameService.pause()
    }

    @IBAction func startButtonPressed(_ sender: UIButton) {
        mediaPlayerService.playSoundtrack()
        gameService.play()
        lastTetrominoPosition = gameService.currentTetromino!.squares
        drawCurrentTetromino()
    }
    
    @IBAction func leftButtonPressed(_ sender: UIButton) {
        gameService.moveLeft()
    }
    
    @IBAction func rightButtonPressed(_ sender: UIButton) {
        gameService.moveRight()
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        // TODO: move literal to a keys class or something like it
        self.performSegue(withIdentifier: "goToSettings", sender: self)
    }
    
    func tetrominoHasMoved() {
        eraseCurrentTetrominoLastPosition()
        drawCurrentTetromino()
        lastTetrominoPosition = gameService!.currentTetromino!.squares
    }
    
    // TODO: move all board view to another controller
    
    func eraseCurrentTetrominoLastPosition(){
        if lastTetrominoPosition != nil{
            eraseSquare(square: lastTetrominoPosition!.firstSquare)
            eraseSquare(square: lastTetrominoPosition!.secondSquare)
            eraseSquare(square: lastTetrominoPosition!.thirdSquare)
            eraseSquare(square: lastTetrominoPosition!.fourthSquare)
        }
    }
    
    func eraseSquare(square: Square){
        let squareView = boardPositionAndSubviewRelation[squareKey(square: square)]
        squareView?.removeFromSuperview()
    }
    
    func drawCurrentTetromino(){
        drawSquare(square: gameService.currentTetromino!.squares.firstSquare, color: gameService.currentTetromino!.color)
        drawSquare(square: gameService.currentTetromino!.squares.secondSquare, color: gameService.currentTetromino!.color)
        drawSquare(square: gameService.currentTetromino!.squares.thirdSquare, color: gameService.currentTetromino!.color)
        drawSquare(square: gameService.currentTetromino!.squares.fourthSquare, color: gameService.currentTetromino!.color)
    }
    
    func drawSquare(square: Square, color: UIColor){
        let squareView : UIView = createSquare(
            x: Float(square.boardColumn) * squareSize,
            y: Float(square.boardRow) * squareSize,
            color: color)
        boardView.addSubview(squareView)
        boardPositionAndSubviewRelation[squareKey(square: square)] = squareView
    }
    
    func squareKey(square: Square) -> String{
        return "\(square.boardRow)_\(square.boardColumn)"
    }
    
    func createSquare(x: Float, y: Float, color: UIColor) -> UIView{
        let viewRectFrame = CGRect(x: CGFloat(x), y: CGFloat(y), width: CGFloat(squareSize), height: CGFloat(squareSize))
        let retView = UIView(frame: viewRectFrame)
        retView.backgroundColor = color
        retView.alpha = CGFloat(1.0)
        return retView
    }
    
    func drawEntireBoard(){
        // TODO:
    }
    
}
