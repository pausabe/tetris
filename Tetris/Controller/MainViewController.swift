//
//  ViewController.swift
//  Tetris
//
//  Created by Pau Sabé Martínez on 31/8/22.
//

import UIKit

class MainViewController: UIViewController {
    
    var mediaPlayerService : MediaPlayerServiceProtocol! = nil
    var stepsService : StepsServiceProtocol! = nil
    
    @IBOutlet weak var test: UIView!
    
    // TODO: move timer to a sevice
    var timer = Timer()
    var timerRunning : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDependencies()
    }
    
    public func loadDependencies(
        mediaPlayerService : MediaPlayerServiceProtocol? = nil,
        stepsService : StepsServiceProtocol? = nil){
            self.mediaPlayerService = mediaPlayerService ?? MediaPlayerService.shared
            self.stepsService = stepsService ?? StepsService.shared
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        pauseGame()
    }

    @IBAction func startButtonPressed(_ sender: UIButton) {
        mediaPlayerService.playSoundtrack()
        test.frame.origin.x = CGFloat(stepsService.startingPositionX)
        test.frame.origin.y = CGFloat(stepsService.startingPositionY)
        
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector: #selector(timerTick), userInfo: nil, repeats: true)
    }
    
    @IBAction func leftButtonPressed(_ sender: UIButton) {
        test.frame.origin.x -= CGFloat(stepsService.verticalStep)
    }
    
    @IBAction func rightButtonPressed(_ sender: UIButton) {
        test.frame.origin.x += CGFloat(stepsService.horizontalStep)
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        // TODO: move literal to a keys class or something like it
        self.performSegue(withIdentifier: "goToSettings", sender: self)
    }
    
    @objc func timerTick(){
        test.frame.origin.y += CGFloat(stepsService.verticalStep)
        stepsService.increaseSpeed()
    }
    
    func pauseGame(){
        timer.invalidate()
    }
    
}

