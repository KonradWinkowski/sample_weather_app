//
//  Wind.swift
//  sample_weather_app
//
//  Created by Konrad Winkowski on 4/29/18.
//  Copyright © 2018 Konrad Winkowski. All rights reserved.
//

import Foundation

struct Wind: Codable {
    
    let degrees: Float
    let speed_kts: Float
    let speed_mph: Float
    let speed_mps: Float
    let gust_kts: Float?
    let gust_mph: Float?
    let gust_mps: Float?
    
}
