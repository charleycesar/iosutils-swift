//
//  ImageMetadataUtils.swift
//  Pods
//
//  Created by Guilherme Politta on 6/07/16.
//
//

import UIKit
import SimpleExif
import CoreLocation

open class ImageMetadataUtils: NSObject {

    //MARK: - Helpers
    
    open func getCurrentLocation() throws -> CLLocation {
        let gpsUtils = GPSUtils()
        let location = try gpsUtils.getCurrentLocation()
        
        return location
    }
    
    //MARK: - Location
    
    open func writeCurrentLocationInfoOnImage(_ image: UIImage) throws -> Data {
        return try writeLocationInfo(getCurrentLocation(), onImage: image)
    }
    
    open func writeLocationInfo(_ location: CLLocation, onImage image: UIImage) throws -> Data {
        let container: ExifContainer = ExifContainer()
        container.add(location)
        
        guard let imageData = image.addExif(container) , imageData.count > 0 else {
            throw NSError(domain: "ImageMetadataUtilsDomain", code: 0, userInfo: [NSLocalizedDescriptionKey : "Erro ao adicionar informações de GPS na imagem"])
        }
        
        return imageData
    }
    
    //MARK: - Other Metadata
    
    open func writeMetadatas(_ metadatas: [String], onImage image: UIImage) throws -> Data {
        let metadata = metadatas.joined(separator: "\n")
        
        let container: ExifContainer = ExifContainer()
        container.addUserComment(metadata)
        
        guard let imageData = image.addExif(container) , imageData.count > 0 else {
            throw NSError(domain: "ImageMetadataUtilsDomain", code: 0, userInfo: [NSLocalizedDescriptionKey : "Erro ao adicionar metadados na imagem"])
        }
        
        return imageData
    }
    
    //MARK: - Location+Other Metadata
    
    open func writeCurrentLocationAndOthersMetadatas(_ metadatas: [String], onImage image: UIImage) throws -> Data {
        return try writeLocation(getCurrentLocation(), andOthersMetadatas: metadatas, onImage: image)
    }
    
    open func writeLocation(_ location: CLLocation, andOthersMetadatas metadatas: [String], onImage image: UIImage) throws -> Data {
        
        let metadata = metadatas.joined(separator: "\n")
        
        let container: ExifContainer = ExifContainer()
        container.addUserComment(metadata)
        container.add(location)
        
        guard let imageData = image.addExif(container) , imageData.count > 0 else {
            throw NSError(domain: "ImageMetadataUtilsDomain", code: 0, userInfo: [NSLocalizedDescriptionKey : "Erro ao adicionar metadados na imagem"])
        }
        
        return imageData
    }
}
