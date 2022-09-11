//
//  ViewController.swift
//  Tetris
//
//  Created by Pau Sabé Martínez on 31/8/22.
//

import UIKit
import SwiftUI

// set score on view
// long press movement buttons
// visual grid

class MainViewController: UIViewController, GameServiceDelegate {

    var mediaPlayerService : MediaPlayerServiceProtocol! = nil
    var gameService : GameServiceProtocol! = nil
    
    var boardPositionAndSubviewRelation: [String: UIView] = [:]
    var lastTetrominoPosition: TetrominoSquares?
    var squareSize: Float = 0
    var rowNumber: Int = 0
    var columnNumber: Int = 0
    var boardView: UIView!
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var gameView: UIView!
    
    override func viewDidLoad() {
        // TODO: move hex color to Keys file
        mainView.applyGradient(colours: [ViewHelper.getColorByHex(rgbHexValue: 0x033650), .black])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        defineBoard()
        addServicesToLocator()
        loadDependencies()
    }
    
    func addServicesToLocator(){
        ServiceLocator.shared.addService(service: TimerService())
        ServiceLocator.shared.addService(service: BoardService(rows: rowNumber, columns: columnNumber))
        ServiceLocator.shared.addService(service: TetrominoHelper())
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
        let gameWidth: Float = Float(gameView.frame.size.width)
        
        let maximumRows = Int(floor(gameHeight / startingSquareSize))
        squareSize = Float(gameHeight) / Float(maximumRows)
        rowNumber = Int(floor(gameHeight / squareSize))
        columnNumber = Int(floor(gameWidth / squareSize))
        
        let boardWidth = Float(columnNumber) * squareSize
        let xOffsetToCenterBoard: Float = (gameWidth - boardWidth) / 2
        
        let viewRectFrame = CGRect(x: CGFloat(xOffsetToCenterBoard), y: CGFloat(0), width: CGFloat(boardWidth), height: CGFloat(Float(rowNumber) * squareSize))
        boardView = UIView(frame: viewRectFrame)
        // TODO: move color somwhere else
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
    
    @IBAction func downButtonPressed(_ sender: UIButton) {
        gameService.moveDown()
    }
    
    @IBAction func rotateButtonPressed(_ sender: UIButton) {
        gameService.rotate()
    }
    
    func tetrominoHasMoved() {
        eraseCurrentTetrominoLastPosition()
        drawCurrentTetromino()
        lastTetrominoPosition = gameService!.currentTetromino!.squares
    }
    
    func newTetrominoAdded() {
        drawCurrentTetromino()
        lastTetrominoPosition = gameService!.currentTetromino!.squares
    }
    
    func gameOver() {
        // TODO:
        print("game over")
    }
    
    func fullRowCleared() {
        // TODO:
        print("full row. score: \(gameService.currentScore)")
        drawEntireBoard()
    }
    
    // TODO: move all board view to another controller
    
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
    
    func drawCurrentTetromino(){
        drawSquare(gameService.currentTetromino!.squares.firstSquare, gameService.currentTetromino!.color)
        drawSquare(gameService.currentTetromino!.squares.secondSquare, gameService.currentTetromino!.color)
        drawSquare(gameService.currentTetromino!.squares.thirdSquare, gameService.currentTetromino!.color)
        drawSquare(gameService.currentTetromino!.squares.fourthSquare, gameService.currentTetromino!.color)
    }
    
    func drawSquare(_ square: Square, _ color: UIColor){
        let squareView : UIView = createSquare(
            x: Float(square.column) * squareSize,
            y: Float(square.row) * squareSize,
            color: color)
        
        /*let squareView : UIView = UIImageView(image: UIImage(named: "launch_icon"))
        squareView.frame = CGRect(x: CGFloat(Float(square.boardColumn) * squareSize), y: CGFloat(Float(square.boardRow) * squareSize), width: CGFloat(squareSize), height: CGFloat(squareSize))*/
        
        boardView.addSubview(squareView)
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
    
}
