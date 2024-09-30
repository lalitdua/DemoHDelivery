//
//  Extensions.swift
//  HaatDemo
//
//  Created by Dhairya on 28/09/24.
//

import Foundation
import UIKit

extension UIView {
    
    func addDottedBorderAtBottom() {
        // Create a CAShapeLayer
        let shapeLayer = CAShapeLayer()
        
        // Define the line's path
        let path = UIBezierPath()
        let startPoint = CGPoint(x: 0, y: self.bounds.height)
        let endPoint = CGPoint(x: self.bounds.width, y: self.bounds.height)
        
        // Move to the starting point
        path.move(to: startPoint)
        // Draw the line to the ending point
        path.addLine(to: endPoint)
        
        // Assign the path to the shape layer
        shapeLayer.path = path.cgPath
        
        // Set the line properties
        shapeLayer.strokeColor = UIColor.lightGray.cgColor  // Change color as needed
        shapeLayer.lineWidth = 1.0  // Set line thickness
        shapeLayer.lineDashPattern = [4, 4]  // Dotted line: 4 points drawn, 4 points space
        
        // Set the shape layer's frame
        shapeLayer.frame = self.bounds
        
        // Add the shape layer to the view's layer
        self.layer.addSublayer(shapeLayer)
    }
    
    // Function to round specific corners with a given radius
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
}


extension UIColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        let length = hexSanitized.count

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 1.0

        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
        } else {
            return nil
        }

        self.init(red: r, green: g, blue: b, alpha: a)
    }
}
