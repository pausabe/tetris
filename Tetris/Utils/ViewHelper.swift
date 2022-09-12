//
//  ViewGradientExtension.swift
//  Tetris
//
//  Created by Pau Sabé Martínez on 11/9/22.
//

import UIKit

extension UIView {

    @discardableResult func applyGradient(colours: [UIColor]) -> CAGradientLayer {
        return self.applyGradient(colours: colours, locations: nil)
    }

    @discardableResult func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
}

@IBDesignable extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
              layer.cornerRadius = newValue

              // If masksToBounds is true, subviews will be
              // clipped to the rounded corners.
              layer.masksToBounds = (newValue > 0)
        }
    }
}

class ViewHelper{
    static func getColorByHex(rgbHexValue:UInt32, alpha:Double = 1.0) -> UIColor {
        let red = Double((rgbHexValue & 0xFF0000) >> 16) / 256.0
        let green = Double((rgbHexValue & 0xFF00) >> 8) / 256.0
        let blue = Double((rgbHexValue & 0xFF)) / 256.0

        return UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
    }
}

class GridView: UIView {
    func drawGrid(gridWidth: CGFloat, color: UIColor, lineWidth: CGFloat) {
        let gridPath = UIBezierPath()

        // Horizontal
        var pointLeft = CGPoint(x: 0, y: 0)
        var pointRight = CGPoint(x: bounds.size.width, y: 0)
        while pointLeft.y <= bounds.height {
            gridPath.move(to: pointLeft)
            gridPath.addLine(to: pointRight)
            pointLeft.y = pointLeft.y + gridWidth
            pointRight.y = pointRight.y + gridWidth
        }
        
        // Vertical
        var pointTop = CGPoint(x: 0, y: 0)
        var pointBottom = CGPoint(x: 0, y: bounds.size.height)
        while (pointTop.x - 1) <= bounds.width {
            gridPath.move(to: pointTop)
            gridPath.addLine(to: pointBottom)
            pointTop.x = pointTop.x + gridWidth
            pointBottom.x = pointBottom.x + gridWidth
        }
        
        let gridLayer = CAShapeLayer()
        gridLayer.frame = bounds
        gridLayer.path = gridPath.cgPath
        gridLayer.strokeColor = color.cgColor
        gridLayer.lineWidth = lineWidth
        layer.addSublayer(gridLayer)
    }
}
