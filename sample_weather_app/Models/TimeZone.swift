//
//  TimeZone.swift
//  sample_weather_app
//
//  Created by Konrad Winkowski on 4/28/18.
//  Copyright © 2018 Konrad Winkowski. All rights reserved.
//

import Foundation

struct TimeZone: Codable {
    
    public let gmt : Int
    public let dst : Int
    public let tzid: String
    
}
