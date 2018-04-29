//
//  Metar.swift
//  sample_weather_app
//
//  Created by Konrad Winkowski on 4/29/18.
//  Copyright © 2018 Konrad Winkowski. All rights reserved.
//

import Foundation

struct Metar: Codable {
    
    static let metarDateFormatter: DateFormatter = DateFormatter()
    
    let icao: String
    let name: String
    let observed: String
    let raw_text: String
    let barometer: Baromoter
    let ceiling: Ceiling?
    let clouds: [Clouds]
    let dewpoint: Temperature
    let elevation: Elevation
    let flight_category: String
    let humidity_percent: Float
    let temperature: Temperature
    let visibility: Visibility
    let wind: Wind
    
    var date: Date? {
        Metar.metarDateFormatter.dateFormat = "dd-MM-YYYY '@' HH:mmz"
        return Metar.metarDateFormatter.date(from: observed)
    }
    
}
