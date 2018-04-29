//
//  Metars.swift
//  sample_weather_app
//
//  Created by Konrad Winkowski on 4/29/18.
//  Copyright © 2018 Konrad Winkowski. All rights reserved.
//

import Foundation

struct Metars: Codable {
    
    enum CodingKeys: String, CodingKey {
        case results = "results"
        case metars = "data"
    }
    
    let results: Int
    let metars: [Metar]
    
}
