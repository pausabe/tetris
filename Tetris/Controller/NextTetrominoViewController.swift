//
//  NextTetrominoViewController.swift
//  Tetris
//
//  Created by Pau Sabé Martínez on 13/9/22.
//

import Foundation
import SwiftUI

class NextTetrominoViewController : UIViewController{
    func drawNextTetromino(_ nextTetromino: Tetromino){
        self.view.subviews.forEach({ $0.removeFromSuperview() })
        
        var verticalPadding: Float = 5
        let containerWidth = Float(self.view.frame.size.width)
        let containerHeight = Float(self.view.frame.size.height) - (verticalPadding * 2)
        let rows = 4
        let columns = 4
        let squareSize = containerHeight / Float(rows)
        let horizontalPadding = (containerWidth - containerHeight) / 2
        
        let freeVerticalSquares = freeVerticalSquares(nextTetromino, rows)
        verticalPadding += Float(freeVerticalSquares) * squareSize / 2
        
        drawNextTetrominoSquare(nextTetromino.squares.firstSquare, nextTetromino.color,  horizontalPadding, verticalPadding, squareSize, rows, columns)
        drawNextTetrominoSquare(nextTetromino.squares.secondSquare, nextTetromino.color, horizontalPadding, verticalPadding, squareSize, rows, columns)
        drawNextTetrominoSquare(nextTetromino.squares.thirdSquare, nextTetromino.color, horizontalPadding, verticalPadding, squareSize, rows, columns)
        drawNextTetrominoSquare(nextTetromino.squares.fourthSquare, nextTetromino.color, horizontalPadding, verticalPadding, squareSize, rows, columns)
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
    
    func drawNextTetrominoSquare(_ square: Square, _ color: UIColor, _ horizontalPadding: Float, _ verticalPadding: Float, _ squareSize: Float, _ rows: Int, _ columns: Int){
        let row = square.row % rows
        let column = square.column % columns
        let x = horizontalPadding + (Float(column) * squareSize)
        let y = verticalPadding + (Float(row) * squareSize)
        self.view.addSubview(TetrominoDrawer.generateSquareView(
            x: x,
            y: y,
            squareSize: squareSize,
            color: color))
    }
}
