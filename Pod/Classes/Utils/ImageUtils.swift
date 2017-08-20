//
//  ImageUtils.swift
//  Pods
//
//  Created by Livetouch BR on 6/23/16.
//
//

import UIKit

open class ImageUtils: NSObject {
    
    static open func getOriginalImageWithName(_ name:String) -> UIImage?{
        guard let image = UIImage(named: name) else {
            return nil
        }
        
        return image.withRenderingMode(.alwaysOriginal)
    }
    
    static open func changeTintOfImageView(_ imageView:UIImageView, toColor color:UIColor){
        guard let image = imageView.image else {
            return
        }
        
        imageView.image = image.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = color
    }
    
    static open func getImageFromColor(_ color:UIColor) -> UIImage{
        return self.getImageFromColor(color, whitRect: CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))
    }

    static open func getImageFromColor(_ color:UIColor, whitRect rect:CGRect) -> UIImage{
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }

    static open func resizeImage(_ image:UIImage, withMaxWidthOrHeight max:CGFloat) -> UIImage{
        let newSize = self.getNewSizeForImage(image, withMaxWidthOrHeight: max)
        
        return self.resizeImage(image, toSize: newSize)
    }

    static open func resizeImage(_ image:UIImage, toSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    static open func getNewSizeForImage(_ image:UIImage, withMaxWidthOrHeight max:CGFloat) -> CGSize{
        var size:CGSize = CGSize(width: 0, height: 0)
        
        if(image.size.width > image.size.height){
            let propotion = image.size.height / image.size.width
            size.width = max
            size.height = max * propotion
        }else{
            let propotion = image.size.width / image.size.height
            size.height = max
            size.width = max * propotion
        }
        
        return size
    }
}
