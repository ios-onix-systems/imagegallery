//
//  LocationService.swift
//  TestTask
//
//  Created by Serhiy on 5/22/18.
//  Copyright © 2018 Serhiy. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

enum LocationErrorType{
    case notEnabled
    case accessDenied
}

protocol LocationServiceProtocol {
    func onError(e: LocationErrorType)
}

class LocationService: NSObject, CLLocationManagerDelegate {
    
    var delegate: LocationServiceProtocol?
    
    private var locationManager: CLLocationManager
    private var isInitialCoordinates: Bool = true
    
    override init() {
        
        locationManager = CLLocationManager()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.distanceFilter = 300
        locationManager.requestAlwaysAuthorization()
        super.init()
        locationManager.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.last else {
            return
        }
        let dtNow = Date()
        let interval = dtNow.timeIntervalSince(userLocation.timestamp)
        if interval > 10 {
            //assume that date older then 10 seconds is cached, so ignore it
            if isInitialCoordinates {
                locationManager.requestLocation()
            }
            return
        }
        if isInitialCoordinates {
            //locationManager.startMonitoringSignificantLocationChanges()
            locationManager.startUpdatingLocation()
            isInitialCoordinates = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LocationService: " + error.localizedDescription)
    }
    
    func startRetrieveLocation(){
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .authorizedAlways:
                locationManager.requestLocation()
            default:
                delegate?.onError(e: .accessDenied)
            }
        } else {
            delegate?.onError(e: .notEnabled)
        }
    }
    
    func stopRetrieveLocation(){
        locationManager.stopUpdatingLocation()
        isInitialCoordinates = true
        //locationManager.stopMonitoringSignificantLocationChanges()
    }
}

class LocationServiceFactory {
    static func `default`() -> LocationService {
        return LocationService()
    }
    
}
