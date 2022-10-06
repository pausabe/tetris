//
//  SettingsViewController.swift
//  Tetris
//
//  Created by Pau Sabé Martínez on 5/9/22.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private let defaults = UserDefaults.standard
    
    @IBOutlet weak var audioSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioSwitch.isOn = defaults.bool(forKey: StoreKeys.audioIsEnabled)
    }

    @IBAction func audioSwitchValueChanged(_ sender: UISwitch) {
        defaults.set(audioSwitch.isOn, forKey: StoreKeys.audioIsEnabled)
    }

}
