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
    var rowNumber: Int = 0
    var columnNumber: Int = 0
    let squareSize: Float = 20
    
    @IBOutlet weak var boardView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: subcribe to GameService events
        
        defineBoardSize()
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
    
    func defineBoardSize(){
        rowNumber = Int(floor(Float(boardView.frame.size.height) / squareSize))
        columnNumber = Int(floor(Float(boardView.frame.size.width) / squareSize))
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
