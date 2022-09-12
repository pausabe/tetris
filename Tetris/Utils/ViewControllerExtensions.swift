//
//  ViewControllerExtensions.swift
//  Tetris
//
//  Created by Pau Sabé Martínez on 12/9/22.
//

import UIKit
import SwiftUI

extension UIViewController {
    /// Add a child UIViewController to a given UIView. If `view` is set to nil or not set, it will add the child the ViewController's view.
    /// - Parameters:
    ///   - child: Child view controller as a UIViewController
    ///   - view: Target UIVew that will contain the child
    func add(_ child: UIViewController, view: UIView? = nil) {
        let view: UIView = view ?? self.view
        addChild(child)
        child.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(child.view)
        NSLayoutConstraint.activate([
            child.view.topAnchor.constraint(equalTo: view.topAnchor),
            child.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            child.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            child.view.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
        child.didMove(toParent: self)
    }


    /// Remove a child viewController from it's container
    func remove() {
        guard parent != nil else {
            return
        }
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
