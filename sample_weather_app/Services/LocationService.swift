//
//  LocationManager.swift
//  sample_weather_app
//
//  Created by Konrad Winkowski on 4/28/18.
//  Copyright © 2018 Konrad Winkowski. All rights reserved.
//

import Foundation
import CoreLocation

final class LocationService: NSObject {

    public static let service: LocationService = LocationService()

    private let locationManager: CLLocationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        
        if isAuthorized {
            setupLocationChanges()
        }
        
    }
    
    public var isAuthorized: Bool {
        return CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways
    }
    
    public var isDenied: Bool {
        return CLLocationManager.authorizationStatus() == .denied
    }
    
    // MARK: Authorization
    public func requestLocationUsage() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func setupLocationChanges() {
        locationManager.distanceFilter = CLLocationDistance(floatLiteral: 500)
        locationManager.startUpdatingLocation()
    }
    
}

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        WeatherDataService.service.update(nearAirportsBasedOn: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        dump(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if isAuthorized {
            setupLocationChanges()
        }
        
        NotificationCenter.default.post(name: WeatherAppNotifications.LocationServices.authorizationStatusNotification, object: status)
    }
    
    
}

