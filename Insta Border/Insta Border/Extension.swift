//
//  Extension.swift
//  Insta Border
//
//  Created by Ayushi on 2020-05-17.
//  Copyright © 2020 Ayushi. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    convenience init(view: UIView) {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage)!)
        
    }
    
}

extension UIColor {
    
    convenience init(_ hexString: String, alpha: Double = 1.0) {
           let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
           var int = UInt64()
           Scanner(string: hex).scanHexInt64(&int)

           let r, g, b: UInt64
           switch hex.count {
           case 3: // RGB (12-bit)
               (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
           case 6: // RGB (24-bit)
               (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
           default:
               (r, g, b) = (1, 1, 0)
           }

           self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(255 * alpha) / 255)
       }
}
