//
//  EmailAttachment.swift
//  Pods
//
//  Created by Livetouch-Mini01 on 04/08/2016.
//
//

import UIKit

open class EmailAttachment: NSObject {
    
    //MARK: - Variables
    
    fileprivate var data    : Data!
    
    fileprivate var type    : String!
    fileprivate var filename: String!
    
    //MARK: - Inits
    
    ///compressionQuality é um número de 0.0 a 1.0
    public init(jpegImage: UIImage, compressionQuality: CGFloat = 1.0, filename: String) {
        self.data = UIImageJPEGRepresentation(jpegImage, compressionQuality)
        self.type = "image/jpeg"
        self.filename = filename
    }
    
    public init(pngImage: UIImage, filename: String) {
        self.data = UIImagePNGRepresentation(pngImage)
        self.type = "image/png"
        self.filename = filename
    }
    
    public init(data: Data, type: String, filename: String) {
        self.data = data
        self.type = type
        self.filename = filename
    }
    
    //MARK: - Getters
    
    open func getData() -> Data {
        return data
    }
    
    open func getType() -> String {
        return type
    }
    
    open func getFilename() -> String {
        return filename
    }
}
