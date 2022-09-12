//
//  ViewController.swift
//  Tetris
//
//  Created by Pau Sabé Martínez on 31/8/22.
//

import UIKit
import SwiftUI

// key-value files
// play pause
// music loop
// all store things
// make some things private

class MainViewController: UIViewController, GameServiceDelegate {

    var boardViewController = BoardViewController()
    var mediaPlayerService : MediaPlayerServiceProtocol! = nil
    var gameService : GameServiceProtocol! = nil
    var buttonFireModeTimer: Timer?
    var fireTimerInterval: Float = 0.1
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    @IBOutlet weak var currentScoreLabel: UILabel!
    @IBOutlet weak var bestScoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.add(boardViewController, view: gameView)
        
        // TODO: move hex color to Keys file
        mainView.applyGradient(colours: [ViewHelper.getColorByHex(rgbHexValue: 0x0c5a82), .black])
        
        leftButton.addTarget(self, action: #selector(leftButtonPressed), for: .touchDown)
        leftButton.addTarget(self, action: #selector(buttonReleased), for: [.touchUpInside, .touchUpOutside])
        rightButton.addTarget(self, action: #selector(rightButtonPressed), for: .touchDown)
        rightButton.addTarget(self, action: #selector(buttonReleased), for: [.touchUpInside, .touchUpOutside])
        downButton.addTarget(self, action: #selector(downButtonPressed), for: .touchDown)
        downButton.addTarget(self, action: #selector(buttonReleased), for: [.touchUpInside, .touchUpOutside])
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
        bestScoreLabel.text = String(0) // TODO:
        currentScoreLabel.text = String(0)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        gameService.pause()
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
        mediaPlayerService.playSoundtrack()
        gameService.play()
        boardViewController.startGame()
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
    
    func newTetrominoAdded() {
        boardViewController.drawNewTetrominoAdded()
    }
    
    func gameOver() {
        // TODO:
        print("game over")
    }
    
    func fullRowCleared() {
        boardViewController.drawEntireBoard()
        currentScoreLabel.text = String(gameService.currentScore)
    }
    
}
