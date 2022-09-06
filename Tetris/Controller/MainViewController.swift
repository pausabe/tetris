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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: subcribe to GameService events
        
        addServicesToLocator()
        loadDependencies()
    }
    
    func addServicesToLocator(){
        ServiceLocator.shared.addService(service: TimerService())
        ServiceLocator.shared.addService(service: BoardService())
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

        gameService.pause()
    }

    @IBAction func startButtonPressed(_ sender: UIButton) {
        mediaPlayerService.playSoundtrack()
        gameService.play()
        drawCurrentTetromino()
    }
    
    @IBAction func leftButtonPressed(_ sender: UIButton) {
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
        //test.frame.origin.x += CGFloat(gameService.horizontalStep)
        
        // TODO: same as left
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        // TODO: move literal to a keys class or something like it
        self.performSegue(withIdentifier: "goToSettings", sender: self)
    }
    
    func drawCurrentTetromino(){
        // TODO:
    }
    
    func drawEntireBoard(){
        // TODO:
    }
    
}
