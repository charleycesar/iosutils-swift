//
//  ImageResizeUtils.swift
//  Pods
//
//  Created by Guilherme Politta on 7/07/16.
//
//

import UIKit


//Nao esta sendo usando esse enum ainda, mas no futuro quero fazer
//com que voce possa escolher uma dessas opcoes, entao vou deixar aqui
public enum ResizeMode {
    case automatic
    case fitToWidth
    case fitToHeight
}

open class ImageResizeUtils: NSObject {
    
    open static func imageWithImage(_ image: UIImage, maxWidthOrHeight max: CGFloat) -> UIImage {
        let newSize = getNewSizeForImage(image, maxWidthOrHeight: max)
        
        return imageWithImage(image, scaledToSize: newSize)
    }
    
    open static func imageWithImage(_ image: UIImage, scaledToSize newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    open static func getNewSizeForImage(_ image: UIImage, maxWidthOrHeight max: CGFloat) -> CGSize {
        var size = CGSize.zero
        
        if (image.size.width > image.size.height) {
            size.width = max
            let propotion = image.size.height / image.size.width
            size.height = max * propotion
        } else {
            size.height = max
            let propotion = image.size.width / image.size.height
            size.width = max * propotion
        }
        
        return size
    }
}
