//
//  TetrominoDrawer.swift
//  Tetris
//
//  Created by Pau Sabé Martínez on 13/9/22.
//

import Foundation
import UIKit

class TetrominoDrawer {
    static let squarePadding: Float = 0.4
    
    static func generateSquareView(x: Float, y: Float, squareSize: Float, color: UIColor) -> UIView{
        let viewRectFrame = CGRect(x: CGFloat(x + squarePadding), y: CGFloat(y + squarePadding), width: CGFloat(squareSize - squarePadding), height: CGFloat(squareSize - squarePadding))
        let squareView = UIView(frame: viewRectFrame)
        squareView.backgroundColor = color
        squareView.alpha = CGFloat(1.0)
        return squareView
    }
}
