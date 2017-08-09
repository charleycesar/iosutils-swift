//
//  CameraUtils.swift
//  Pods
//
//  Created by Guilherme Politta on 5/07/16.
//
//

import UIKit
import Foundation
import CoreLocation
import MobileCoreServices

public protocol CameraUtilsDelegate {
    func userDidTakePhoto(_ photo: UIImage)
    func userDidCancel()
    func userDidSelectImage(_ image: UIImage)
}

open class CameraUtils: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: - Public Variables
    
    var delegate: CameraUtilsDelegate?
    
    var imagePickerController: UIImagePickerController?
    
    //MARK: - Private Variables
    
    static var openCamera   : CameraUtils?
    
    //MARK: - Image Picker Controller Delegate
    
    open func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info.getStringWithKey(UIImagePickerControllerMediaType)
        
        if (mediaType == kUTTypeImage as String) {
            guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
                AlertUtils.alert("Ocorreu um erro ao obter a imagem")
                return
            }
            
            if (picker.sourceType == .camera) {
                self.delegate?.userDidTakePhoto(image)
            } else {
                self.delegate?.userDidSelectImage(image)
            }
            
        } else {
            AlertUtils.alert("Somente imagens são aceitas")
        }
        
        CameraUtils.openCamera = nil
        picker.dismiss(animated: true, completion: nil)
    }
    
    open func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.delegate?.userDidCancel()
        
        CameraUtils.openCamera = nil
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - Camera
    
    /**
       Verifica se a camera do dispositivo está disponivel ou não.
       - Returns: Verdadeiro se a camera está disponível e Falso caso o contrário.
     */
    open static func isCameraAvailable() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    /**
     
     - Returns:
     */
    open static func getCamera<T>(_ delegate: T) -> UIImagePickerController? where T: UIImagePickerControllerDelegate, T: UINavigationControllerDelegate {
        
        if (!isCameraAvailable()) {
            return nil
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = delegate
        imagePicker.sourceType = .camera
        imagePicker.cameraCaptureMode = .photo
        imagePicker.allowsEditing = false
        
        return imagePicker
    }
    
    /**
     
     
     - Parameters:
        - delegate: 
     
        - presentIn:
     
     - Returns:
     */
    open static func openCameraWithDelegate(_ delegate: CameraUtilsDelegate, presentInViewController presentIn: UIViewController) -> CameraUtils? {
        let cameraUtils = CameraUtils()
        cameraUtils.delegate = delegate
        
        if let ipc = CameraUtils.getCamera(cameraUtils) {
            presentIn.present(ipc, animated: true, completion: nil)
        } else {
            return nil
        }
        
        CameraUtils.openCamera = cameraUtils
        
        return cameraUtils
    }
    
    //MARK: - Photo Library
    
    /**
       Verifica se a galeria de fotos do dispositivo está disponível ou não.
       - Returns: Verdadeiro se estiver disponível e Falso caso o contrário.
     */
    open static func isPhotoLibraryAvailable() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
    }
    
    /**
     
     - Returns:
     */
    open static func getPhotoLibrary<T>(_ delegate: T) -> UIImagePickerController? where T: UIImagePickerControllerDelegate, T: UINavigationControllerDelegate {
        if (!isPhotoLibraryAvailable()) {
            return nil
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = delegate
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
        return imagePicker
        
    }
    
    /**
     
     
     - Parameters:
        - delegate:
     
        - presentIn:
     
     - Returns:
     */
    open static func openPhotoLibraryWithDelegate(_ delegate: CameraUtilsDelegate, presentInViewController presentIn: UIViewController) -> CameraUtils? {
        let cameraUtils = CameraUtils()
        cameraUtils.delegate = delegate
        
        if let ipc = CameraUtils.getPhotoLibrary(cameraUtils) {
            presentIn.present(ipc, animated: true, completion: nil)
        } else {
            return nil
        }
        
        CameraUtils.openCamera = cameraUtils
        
        return cameraUtils
        
    }
    
    open static func open() {
    
    }
    
//    public static File open(Context context, String fileName, String folderName) {
//    File file = SDCardUtil.getSdCardFile(context, folderName, fileName);
//    LogUtil.log("fileName: " + fileName);
//    return file;
//    }
    
}
