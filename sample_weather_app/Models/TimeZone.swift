//
//  TimeZone.swift
//  sample_weather_app
//
//  Created by Konrad Winkowski on 4/28/18.
//  Copyright © 2018 Konrad Winkowski. All rights reserved.
//

import Foundation

struct TimeZone: Encodable {
    
    public let gmt : Int
    public let dst : Int
    public let tzid: String
    
}

extension TimeZone: Decodable {
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            let str_gmt = try values.decode(String.self, forKey: .gmt)
            if let int_gmt = Int(str_gmt) {
                gmt = int_gmt
            } else {
                gmt = 0
            }
        } catch {
            gmt = try values.decode(Int.self, forKey: .gmt)
        }
        
        do {
            let str_dst = try values.decode(String.self, forKey: .dst)
            if let int_dst = Int(str_dst) {
                dst = int_dst
            } else {
                dst = 0
            }
            
        } catch {
            dst = try values.decode(Int.self, forKey: .dst)
        }
        
        tzid = try values.decode(String.self, forKey: .tzid)
        
    }
    
}
