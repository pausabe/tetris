//
//  ViewController.swift
//  Tetris
//
//  Created by Pau Sabé Martínez on 31/8/22.
//

import UIKit

class MainViewController: UIViewController {
    
    var mediaPlayerService : MediaPlayerServiceProtocol! = nil
    var gameService : GameServiceProtocol! = nil
    
    @IBOutlet weak var test: UIView!
    
    // TODO: move timer to a sevice
    var timer = Timer()
    var timerRunning : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addServicesToLocator()
        loadDependencies()
    }
    
    func addServicesToLocator(){
        ServiceLocator.shared.addService(service: MediaPlayerService())
        ServiceLocator.shared.addService(service: GameService())
    }
    
    // ViewControllers does not have init() constructor. We let accessible this method to load the dependencies as desired
    public func loadDependencies(mediaPlayerService : MediaPlayerServiceProtocol? = nil,
                                 gameService : GameServiceProtocol? = nil){
        self.mediaPlayerService = mediaPlayerService ?? ServiceLocator.shared.getService()! as MediaPlayerServiceProtocol
        self.gameService = gameService ?? ServiceLocator.shared.getService()! as GameServiceProtocol
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        pauseGame()
    }

    @IBAction func startButtonPressed(_ sender: UIButton) {
        
        mediaPlayerService.playSoundtrack()
        test.frame.origin.x = CGFloat(gameService.startingPositionX)
        test.frame.origin.y = CGFloat(gameService.startingPositionY)
        
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector: #selector(timerTick), userInfo: nil, repeats: true)
    }
    
    @IBAction func leftButtonPressed(_ sender: UIButton) {
        test.frame.origin.x -= CGFloat(gameService.verticalStep)
        /*
         TODO:

         if GameServie.MakeLeftMovement(){
            print the current Tetronimio with its new position
         }
         
         // What MakeLeftMovement does:
         - Try tro fit the current Tetronimo into the current board (checking other pieces and the borders)
         - In case of a possible movement, it applyies into the GameServie.BoardMap
            - Saves the color of the current Tetronimo into the MAP possitions
            - Saves the new MAP position into the current Tetronimo model
            - Check if with this movement there is some Row completed and it saves it into GameService.RowCompleted array
         - Returns whether it was possible the movement
         
         */
    }
    
    @IBAction func rightButtonPressed(_ sender: UIButton) {
        test.frame.origin.x += CGFloat(gameService.horizontalStep)
        
        // TODO: same as left
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        // TODO: move literal to a keys class or something like it
        self.performSegue(withIdentifier: "goToSettings", sender: self)
    }
    
    @objc func timerTick(){
        test.frame.origin.y += CGFloat(gameService.verticalStep)
  
        /*
         TODO:
         
         GameService.MoveDown() // Same as move left
         
         var currentGameState = GameService.EvaluateBoardState()
         if currentGameState == GameState.Over {
            print all necessary to intorm user that the game is over
         }
         else{
            redraw all board (maybe this its not always necessary...)
         }
         
         // What EvaluateBoard does:
         - Check if there is a row that can be deleted (checking at GameService.RowCompleted). And in case of a row deltion:
            - Remove row from the GameService.BoardMap moving all the Tetronimos avobe the row
            - Prepare the new current Tetronimo
         - In case of not row deletion, check if position is at bottom. And in case of reached the bottom:
            - Prepare the new current Tetronimo
         - Check if its actually a game over (when we wanted to prepare the new current Tetronimo but it wasant possible to fit it) and updates the GameService.
         - Return the GameService.GameState
         
         */
    }
    
    func pauseGame(){
        // TODO:
        timer.invalidate()
    }
    
}
