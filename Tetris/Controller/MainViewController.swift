//
//  ViewController.swift
//  Tetris
//
//  Created by Pau Sabé Martínez on 31/8/22.
//

import UIKit
import SwiftUI

class MainViewController: UIViewController, GameServiceDelegate {

    var boardViewController = BoardViewController()
    var nextTetrominoViewController = NextTetrominoViewController()
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
        self.add(nextTetrominoViewController, view: nextTetrominoView)
        
        leftButton.addTarget(self, action: #selector(leftButtonPressed), for: .touchDown)
        leftButton.addTarget(self, action: #selector(buttonReleased), for: [.touchUpInside, .touchUpOutside])
        rightButton.addTarget(self, action: #selector(rightButtonPressed), for: .touchDown)
        rightButton.addTarget(self, action: #selector(buttonReleased), for: [.touchUpInside, .touchUpOutside])
        downButton.addTarget(self, action: #selector(downButtonPressed), for: .touchDown)
        downButton.addTarget(self, action: #selector(buttonReleased), for: [.touchUpInside, .touchUpOutside])
        
        if defaults.object(forKey: StoreKeys.audioIsEnabled) == nil{
            defaults.set(true, forKey: StoreKeys.audioIsEnabled)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
    
    /// ViewControllers does not have init() constructor. We let accessible this method to load the dependencies as desired
    public func loadDependencies(mediaPlayerService : MediaPlayerServiceProtocol? = nil,
                                 gameService : GameServiceProtocol? = nil){
        self.mediaPlayerService = mediaPlayerService ?? ServiceLocator.shared.getService()! as MediaPlayerServiceProtocol
        self.gameService = gameService ?? ServiceLocator.shared.getService()! as GameServiceProtocol
        self.gameService.delegate = self
    }
    
    func setScoreLabels(){
        bestScoreLabel.text = String(defaults.integer(forKey: StoreKeys.bestScore))
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
            if defaults.bool(forKey: StoreKeys.audioIsEnabled){
                mediaPlayerService.play(songName: SongKeys.backgroundSong, resourceExtension: MediaPlayerService.mp3Extension)
            }
            setScoreLabels()
            gameService.startGame()
            nextTetrominoViewController.drawNextTetromino(gameService.nextTetromino!)
            boardViewController.clearBoard()
            boardViewController.startBoard()
        }
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: SegueKeys.goToSettings, sender: self)
    }
    
    @IBAction func rotateButtonPressed(_ sender: UIButton) {
        askMovement(.rotation)
    }
    
    func tetrominoHasMoved() {
        boardViewController.drawTetrominoMovement()
    }
    
    func newTetrominoAdded() {
        nextTetrominoViewController.drawNextTetromino(gameService.nextTetromino!)
        boardViewController.drawNewTetrominoAdded()
    }
    
    func gameOver() {
        gameOverButton.isHidden = false
        mediaPlayerService.stop()
        if gameService.currentScore > defaults.integer(forKey: StoreKeys.bestScore){
            defaults.set(gameService.currentScore, forKey: StoreKeys.bestScore)
        }
    }
    
    func fullRowCleared() {
        boardViewController.drawEntireBoard()
        currentScoreLabel.text = String(gameService.currentScore)
    }
    
}
