//
//  GPSUtils.swift
//  Pods
//
//  Created by Guilherme Politta on 5/07/16.
//
//

import UIKit
import CoreLocation

open class GPSUtils: NSObject, CLLocationManagerDelegate {

    //MARK: Public Variables
    
    open var timeout: TimeInterval = 15
    
    //MARK: Private Variables
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    var error: NSError?
    var cancelTimeout: Bool = false
    
    var semaphore: DispatchSemaphore?
    var timeoutTimer: DispatchTime?
    
    //MARK: - Current Location
    
    open func getCurrentLocation() throws -> CLLocation {
        self.semaphore = DispatchSemaphore(value: 0)
        
        self.performSelector(onMainThread: #selector(startLocationManager), with: nil, waitUntilDone: true)
        
        timeoutTimer = DispatchTime.now() + Double((Int64(self.timeout) * Int64(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).asyncAfter(deadline: self.timeoutTimer!, execute: {
            self.requestTimeout()
        })
        
        self.semaphore!.wait(timeout: DispatchTime.distantFuture)
        
        if let error = self.error {
            throw error
        }
        
        if let location = self.currentLocation {
            return location
        }
        
        throw  NSError(domain: "GPSUtilsDomain", code: 2, userInfo: [NSLocalizedDescriptionKey : "Não foi possivel obter a localização do usuário"])
    }
    
    open func startLocationManager() {
        self.locationManager = GPSUtils.startGPS(self, requestAlways: false)
    }
    
    open func requestTimeout() {
        if (self.cancelTimeout) {
            return
        }
        
        self.stopTimeout()
        
        self.error = NSError(domain: "GPSUtilsDomain", code: 2, userInfo: [NSLocalizedDescriptionKey : "Não foi possivel obter a localização do usuário"])
        
        if let semaphore = semaphore {
            semaphore.signal()
        }
    }
    
    open func stopTimeout() {
        self.cancelTimeout = true
        GPSUtils.stopGPS(self.locationManager)
    }
    
    //MARK: - CLLocationManagerDelegate
    
    open func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        GPSUtils.stopGPS(self.locationManager)
        
        self.currentLocation = locations.last
        
        if let semaphore = semaphore {
            semaphore.signal()
        }
    }
    
    open func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.stopTimeout()
        
        self.error = error as NSError?;
        
        if let semaphore = semaphore {
            semaphore.signal()
        }
    }
    
    
    open func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == .denied || status == .restricted) {
            self.stopTimeout()
            
            self.error = NSError(domain: "GPSUtilsDomain", code: 1, userInfo: [NSLocalizedDescriptionKey : "Usuário negou permissão de localização"])
            
            if let semaphore = semaphore {
                semaphore.signal()
            }
        }
    }
    
    //MARK: - Start/Stop
    
    open static func startGPS(_ delegate: CLLocationManagerDelegate, requestAlways: Bool) -> CLLocationManager {
        let locationManager = CLLocationManager()
        locationManager.delegate = delegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if (requestAlways) {
            locationManager.requestAlwaysAuthorization()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.startUpdatingLocation()
        
        return locationManager
    }
    
    open static func stopGPS(_ locationManager: CLLocationManager?) {
        if let locationManager = locationManager {
            locationManager.delegate = nil
            locationManager.stopUpdatingLocation()
        }
    }
    
    //MARK: - Convert
    
    open static func convert(_ value: Double) -> String {
        var latitude = fabs(value)
        
        let degree = Int(latitude)
        latitude *= 60
        latitude -= Double(degree * 60)
        let minute = Int(latitude)
        latitude *= 60
        latitude -= Double(minute * 60)
        let second = Int(latitude * 1000)
        
        let string = "\(degree)/1,\(minute)/1,\(second)/1000,"
        
        return string
    }
    
    //MARK: - Reference
    
    open static func latitudeRef(_ latitude: Double) -> String {
        return latitude < 0 ? "S" : "N"
    }
    
    open static func longitudeRef(_ longitude: Double) -> String {
        return longitude < 0.0 ? "W" : "E"
    }
}
