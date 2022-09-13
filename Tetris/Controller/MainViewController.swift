//
//  ViewController.swift
//  Tetris
//
//  Created by Pau Sabé Martínez on 31/8/22.
//

import UIKit
import SwiftUI

// move next things to another controller?
// key-value files
// music loop
// make some things private
// todos

class MainViewController: UIViewController, GameServiceDelegate {

    var boardViewController = BoardViewController()
    var mediaPlayerService : MediaPlayerServiceProtocol! = nil
    var gameService : GameServiceProtocol! = nil
    var buttonFireModeTimer: Timer?
    var fireTimerInterval: Float = 0.1
    let defaults = UserDefaults.standard

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    @IBOutlet weak var currentScoreLabel: UILabel!
    @IBOutlet weak var bestScoreLabel: UILabel!
    @IBOutlet weak var gameOverButton: UIButton!
    @IBOutlet weak var nextTetrominoView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.add(boardViewController, view: gameView)
        
        leftButton.addTarget(self, action: #selector(leftButtonPressed), for: .touchDown)
        leftButton.addTarget(self, action: #selector(buttonReleased), for: [.touchUpInside, .touchUpOutside])
        rightButton.addTarget(self, action: #selector(rightButtonPressed), for: .touchDown)
        rightButton.addTarget(self, action: #selector(buttonReleased), for: [.touchUpInside, .touchUpOutside])
        downButton.addTarget(self, action: #selector(downButtonPressed), for: .touchDown)
        downButton.addTarget(self, action: #selector(buttonReleased), for: [.touchUpInside, .touchUpOutside])
        
        if defaults.object(forKey: "audioIsEnabled") == nil{
            defaults.set(true, forKey: "audioIsEnabled")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // TODO: move this to ViewDidLoad?
        addServicesToLocator()
        loadDependencies()
        setScoreLabels()
    }
    
    func addServicesToLocator(){
        ServiceLocator.shared.addService(service: TimerService())
        ServiceLocator.shared.addService(service: BoardService())
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
    
    func setScoreLabels(){
        bestScoreLabel.text = String(defaults.integer(forKey: "bestScore"))
        currentScoreLabel.text = String(0)
    }
    
    @objc func leftButtonPressed(_ sender: UIButton) {
        askMovement(.left)
    }
    
    @objc func rightButtonPressed(_ sender: UIButton) {
        askMovement(.right)
    }
    
    @objc func downButtonPressed(_ sender: UIButton) {
        askMovement(.down)
    }
    
    func askMovement(_ direction: MovementDirectionEnum){
        var selector: Selector?
        switch direction {
        case .left:
            askLeftMovement()
            selector = #selector(askLeftMovement)
        case .right:
            askRightMovement()
            selector = #selector(askRightMovement)
        case .down:
            askDownMovement()
            selector = #selector(askDownMovement)
        case .rotation:
            askRotation()
        }
        
        if selector != nil {
            buttonFireModeTimer = Timer.scheduledTimer(timeInterval: TimeInterval(fireTimerInterval), target: self, selector: selector!, userInfo: nil, repeats: true)
        }
    }
    
    @objc func askLeftMovement() {
        gameService.moveLeft()
    }
    
    @objc func askRightMovement() {
        gameService.moveRight()
    }
    
    @objc func askDownMovement() {
        gameService.moveDown()
    }
    
    func askRotation(){
        gameService.rotate()
    }

    @objc func buttonReleased() {
        buttonFireModeTimer?.invalidate()
    }

    @IBAction func startButtonPressed(_ sender: UIButton) {
        if gameService.currentState == .stopped{
            gameOverButton.isHidden = true
            if defaults.bool(forKey: "audioIsEnabled"){
                mediaPlayerService.play(songName: "tetris_soundtrack", resourceExtension: "mp3")
            }
            setScoreLabels()
            gameService.startGame()
            drawNextTetromino()
            boardViewController.clearBoard()
            boardViewController.startBoard()
        }
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        // TODO: move literal to a keys class or something like it
        self.performSegue(withIdentifier: "goToSettings", sender: self)
    }
    
    @IBAction func rotateButtonPressed(_ sender: UIButton) {
        askMovement(.rotation)
    }
    
    func tetrominoHasMoved() {
        boardViewController.drawTetrominoMovement()
    }
    
    // TODO: move next tetro thing to another controller
    
    func newTetrominoAdded() {
        drawNextTetromino()
        boardViewController.drawNewTetrominoAdded()
    }
    
    func drawNextTetromino(){
        nextTetrominoView.subviews.forEach({ $0.removeFromSuperview() })
        
        var verticalPadding: Float = 5
        let containerWidth = Float(nextTetrominoView.frame.size.width)
        let containerHeight = Float(nextTetrominoView.frame.size.height) - (verticalPadding * 2)
        let rows = 4
        let columns = 4
        let squareSize = containerHeight / Float(rows)
        let horizontalPadding = (containerWidth - containerHeight) / 2
        
        let freeVerticalSquares = freeVerticalSquares(gameService.nextTetromino!, rows)
        verticalPadding += Float(freeVerticalSquares) * squareSize / 2
        
        drawNextTetrominoSquare(gameService.nextTetromino!.squares.firstSquare, horizontalPadding, verticalPadding, squareSize, rows, columns)
        drawNextTetrominoSquare(gameService.nextTetromino!.squares.secondSquare, horizontalPadding, verticalPadding, squareSize, rows, columns)
        drawNextTetrominoSquare(gameService.nextTetromino!.squares.thirdSquare, horizontalPadding, verticalPadding, squareSize, rows, columns)
        drawNextTetrominoSquare(gameService.nextTetromino!.squares.fourthSquare, horizontalPadding, verticalPadding, squareSize, rows, columns)
    }
    
    func freeVerticalSquares(_ tetromino: Tetromino, _ rows: Int) -> Int {
        var differentRows = [Int]()
        let firstRow = tetromino.squares.firstSquare.row % rows
        differentRows.append(firstRow)
        let secondRow = tetromino.squares.secondSquare.row % rows
        if !differentRows.contains(secondRow){
            differentRows.append(secondRow)
        }
        let thirdRow = tetromino.squares.thirdSquare.row % rows
        if !differentRows.contains(thirdRow){
            differentRows.append(thirdRow)
        }
        let fourthRow = tetromino.squares.fourthSquare.row % rows
        if !differentRows.contains(fourthRow){
            differentRows.append(fourthRow)
        }
        
        return rows - differentRows.count
    }
    
    func drawNextTetrominoSquare(_ square: Square, _ horizontalPadding: Float, _ verticalPadding: Float, _ squareSize: Float, _ rows: Int, _ columns: Int){
        let row = square.row % rows
        let column = square.column % columns
        let x = horizontalPadding + (Float(column) * squareSize)
        let y = verticalPadding + (Float(row) * squareSize)
        nextTetrominoView.addSubview(TetrominoDrawer.generateSquareView(
            x: x,
            y: y,
            squareSize: squareSize,
            color: gameService.nextTetromino!.color))
    }
    
    func gameOver() {
        gameOverButton.isHidden = false
        mediaPlayerService.stop()
        defaults.set(gameService.currentScore, forKey: "bestScore")
    }
    
    func fullRowCleared() {
        boardViewController.drawEntireBoard()
        currentScoreLabel.text = String(gameService.currentScore)
    }
    
}
