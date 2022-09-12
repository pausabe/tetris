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

class MainViewController: UIViewController, GameServiceDelegate {

    var boardViewController = BoardViewController()
    var mediaPlayerService : MediaPlayerServiceProtocol! = nil
    var gameService : GameServiceProtocol! = nil
    var buttonFireModeTimer: Timer?
    
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
        mainView.applyGradient(colours: [ViewHelper.getColorByHex(rgbHexValue: 0x033650), .black])
        
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
        askMovement(.left, fireModeEnabled: true)
    }
    
    @objc func rightButtonPressed(_ sender: UIButton) {
        askMovement(.right, fireModeEnabled: true)
    }
    
    @objc func downButtonPressed(_ sender: UIButton) {
        askMovement(.down, fireModeEnabled: true)
    }
    
    func askMovement(_ direction: MovementDirectionEnum, fireModeEnabled: Bool = false){
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
        
        if fireModeEnabled && selector != nil {
            // TODO: add timeInterval to a Keys file
            buttonFireModeTimer = Timer.scheduledTimer(timeInterval: 0.15, target: self, selector: selector!, userInfo: nil, repeats: true)
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
        askMovement(.rotation, fireModeEnabled: true)
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
