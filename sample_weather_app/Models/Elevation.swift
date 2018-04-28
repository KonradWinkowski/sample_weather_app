//
//  Elevation.swift
//  sample_weather_app
//
//  Created by Konrad Winkowski on 4/28/18.
//  Copyright © 2018 Konrad Winkowski. All rights reserved.
//

import Foundation

struct Elevation: Codable {
    let feet: Float
    
    public var meter: Float {
        return Float(feet) * 0.3048
    }
    
}
