//
//  PrintScreenUtils.swift
//  Pods
//
//  Created by Livetouch-Mini01 on 06/07/2016.
//
//

import UIKit

open class PrintScreenUtils: NSObject {
    
    //MARK: - Save
    
    static open func printScreen(_ view: UIView?, toJPGFile filename: String) {
        guard let view = view else {
            return
        }
        
        guard let image = getPrintScreen(view) else {
            return
        }
        
        var filename = filename
        
        if (!StringUtils.contains(filename, fromQuery: ".jpg")) {
            filename.append(".jpg")
        }
        
        if let data = UIImageJPEGRepresentation(image, 1.0) {
            do {
                try data.write(to: URL(fileURLWithPath: filename), options: NSData.WritingOptions.withoutOverwriting)
            } catch {
                LogUtils.log("Erro ao salvar print screen no arquivo \(filename).")
            }
        }
    }
    
    static open func printScreen(_ view: UIView?, toPNGFile filename: String) {
        guard let view = view else {
            return
        }
        
        guard let image = getPrintScreen(view) else {
            return
        }
        
        var filename = filename
        
        if (!StringUtils.contains(filename, fromQuery: ".png")) {
            filename.append(".png")
        }
        
        if let data = UIImagePNGRepresentation(image) {
            do {
                try data.write(to: URL(fileURLWithPath: filename), options: NSData.WritingOptions.withoutOverwriting)
            } catch {
                LogUtils.log("Erro ao salvar print screen no arquivo \(filename).")
            }
        }
    }
    
    //MARK: - Get
    
    static open func getPrintScreen(_ view: UIView) -> UIImage? {
        let screenSize = UIScreen.main.applicationFrame.size
        let colorSpaceRef = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.none
        
        guard let ctx = CGContext(data: nil, width: Int(screenSize.width), height: Int(screenSize.height), bitsPerComponent: 8, bytesPerRow: 4 * Int(screenSize.width), space: colorSpaceRef, bitmapInfo: bitmapInfo.rawValue) else {
            return nil
        }
        
        ctx.translateBy(x: 0.0, y: screenSize.height)
        ctx.scaleBy(x: 1.0, y: -1.0)
        
        view.layer.render(in: ctx)
        
        guard let cgImage = ctx.makeImage() else {
            return nil
        }
        
        let image = UIImage(cgImage: cgImage)
        return image
    }
}
