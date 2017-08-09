//
//  UIColor+Livetouch.swift
//  PortoSeguroCartoes
//
//  Created by livetouch PR on 10/15/15.
//  Copyright © 2015 Livetouch Brasil. All rights reserved.
//

import UIKit

public extension UIColor {
    
    class func imageWithColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        
        UIGraphicsBeginImageContext(rect.size)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    class func getColorVar(_ string: String) -> UIColor {
        if (string.characters.count > 0){
            if (string.characters.first == "-") {
                return UIColor(red: 0.980, green: 0.180, blue: 0.180, alpha: 1.0)
            } else {
                return UIColor(red: 0.564, green: 0.866, blue: 0.243, alpha: 1.0)
            }
        }
        return UIColor.gray
    }

    class func colorWithRed(_ red: Int, green: Int, blue: Int, andAlpha alpha: CGFloat) -> UIColor {
        return UIColor(red: red.toCGFloat()/255.0, green: green.toCGFloat()/255.0, blue: blue.toCGFloat()/255.0, alpha: alpha)
    }
    
    class func colorWithRGB(_ rgbValue: Int, andAlpha alpha: CGFloat) -> UIColor {
        return UIColor(red: CGFloat(rgbValue & 0xFF0000 >> 16), green: CGFloat(rgbValue & 0x00FF00 >> 8), blue: CGFloat(rgbValue & 0x0000FF >> 0), alpha: alpha)
    }
    
    /*
    class func colorWithHex (_ hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = cString.substring(from: cString.characters.index(cString.startIndex, offsetBy: 1))
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }*/
}
