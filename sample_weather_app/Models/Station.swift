//
//  Station.swift
//  sample_weather_app
//
//  Created by Konrad Winkowski on 4/28/18.
//  Copyright © 2018 Konrad Winkowski. All rights reserved.
//

import Foundation
import CoreLocation

struct Station: Codable {
    
    public let icao: String
    public let name: String
    public let activated: String?
    public let city: String?
    public let state: State
    public let country: Country
    public let elevation: Elevation
    public let latitude: Coordinate
    public let longitude: Coordinate
    public let magnetic_variation: MagneticVariation?
    public let status: String
    public let timezone: TimeZone?
    public let type: String
    public let useage: String?
    
    public var address: String {
        return "\(String(describing: city)) \(state.name) \(country.name)"
    }
    
    public var location: CLLocation {
        return CLLocation(coordinate: CLLocationCoordinate2D(latitude: latitude.decimal, longitude: longitude.decimal), altitude: Double(elevation.meter), horizontalAccuracy: 5.0, verticalAccuracy: 5.0, timestamp: Date())
    }
    
}
