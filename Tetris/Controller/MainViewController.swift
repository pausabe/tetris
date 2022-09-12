//
//  ViewController.swift
//  Tetris
//
//  Created by Pau Sabé Martínez on 31/8/22.
//

import UIKit
import SwiftUI

// set score on view
// visual grid
// key-value files
// play pause
// music loop
// encapsulate and abstract all board thins in MainViewController

class MainViewController: UIViewController, GameServiceDelegate {

    var mediaPlayerService : MediaPlayerServiceProtocol! = nil
    var gameService : GameServiceProtocol! = nil
    
    var boardPositionAndSubviewRelation: [String: UIView] = [:]
    var lastTetrominoPosition: TetrominoSquares?
    var squareSize: Float = 0
    var rowNumber: Int = 0
    var columnNumber: Int = 0
    var boardView: UIView!
    var timer: Timer?
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightbutton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    
    override func viewDidLoad() {
        // TODO: move hex color to Keys file
        mainView.applyGradient(colours: [ViewHelper.getColorByHex(rgbHexValue: 0x033650), .black])
        
        leftButton.addTarget(self, action: #selector(leftButtonPressed), for: .touchDown)
        leftButton.addTarget(self, action: #selector(buttonReleased), for: [.touchUpInside, .touchUpOutside])
        rightbutton.addTarget(self, action: #selector(rightButtonPressed), for: .touchDown)
        rightbutton.addTarget(self, action: #selector(buttonReleased), for: [.touchUpInside, .touchUpOutside])
        downButton.addTarget(self, action: #selector(downButtonPressed), for: .touchDown)
        downButton.addTarget(self, action: #selector(buttonReleased), for: [.touchUpInside, .touchUpOutside])
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
    
    @objc func leftButtonPressed(_ sender: UIButton) {
        moveLeft()
        timer = Timer.scheduledTimer(timeInterval: 0.15, target: self, selector: #selector(moveLeft), userInfo: nil, repeats: true)
    }
    
    @objc func rightButtonPressed(_ sender: UIButton) {
        moveRight()
        timer = Timer.scheduledTimer(timeInterval: 0.15, target: self, selector: #selector(moveRight), userInfo: nil, repeats: true)
    }
    
    @objc func downButtonPressed(_ sender: UIButton) {
        moveDown()
        timer = Timer.scheduledTimer(timeInterval: 0.15, target: self, selector: #selector(moveDown), userInfo: nil, repeats: true)
    }

    @objc func buttonReleased() {
        timer?.invalidate()
    }

    @objc func moveLeft() {
        gameService.moveLeft()
    }
    
    @objc func moveRight() {
        gameService.moveRight()
    }
    
    @objc func moveDown() {
        gameService.moveDown()
    }

    @IBAction func startButtonPressed(_ sender: UIButton) {
        mediaPlayerService.playSoundtrack()
        gameService.play()
        lastTetrominoPosition = gameService.currentTetromino!.squares
        drawTetromino(gameService!.currentTetromino!)
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        // TODO: move literal to a keys class or something like it
        self.performSegue(withIdentifier: "goToSettings", sender: self)
    }
    
    @IBAction func rotateButtonPressed(_ sender: UIButton) {
        gameService.rotate()
    }
    
    func tetrominoHasMoved() {
        eraseCurrentTetrominoLastPosition()
        drawTetromino(gameService!.currentTetromino!)
        lastTetrominoPosition = gameService!.currentTetromino!.squares
    }
    
    func newTetrominoAdded() {
        drawTetromino(gameService!.currentTetromino!)
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
