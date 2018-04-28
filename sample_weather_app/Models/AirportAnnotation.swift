//
//  AirportAnnotation.swift
//  sample_weather_app
//
//  Created by Konrad Winkowski on 4/28/18.
//  Copyright © 2018 Konrad Winkowski. All rights reserved.
//

import Foundation
import MapKit

final class AirportAnnotation: NSObject, MKAnnotation {
    
    public var coordinate: CLLocationCoordinate2D {
        return station.location.coordinate
    }
    
    public var title: String? {
        return station.name
    }
    
    public var subtitle: String? {
        return station.address
    }
    
    private let station: Station
    
    init(with station: Station) {
        self.station = station
    }
    
}
