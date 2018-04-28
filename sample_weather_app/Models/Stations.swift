//
//  Stations.swift
//  sample_weather_app
//
//  Created by Konrad Winkowski on 4/28/18.
//  Copyright © 2018 Konrad Winkowski. All rights reserved.
//

import Foundation

struct Stations: Codable {
    
    enum CodingKeys: String, CodingKey {
        case results = "results"
        case airports = "data"
    }
    
    let results: Int
    let airports: [Station]
    
}
