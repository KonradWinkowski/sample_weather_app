//
//  WeatherDataService.swift
//  sample_weather_app
//
//  Created by Konrad Winkowski on 4/28/18.
//  Copyright © 2018 Konrad Winkowski. All rights reserved.
//

import Foundation
import CoreLocation

typealias NearbyAirportsCompletion = (_ stations: Stations?, _ error: Error?) -> Void
typealias StationsChangedHandler = (_ stations: Stations) -> Void
typealias MetarInfoCompletion = (_ metar: Metar?, _ error: Error?) -> Void

final class WeatherDataService {
    
    public static let service: WeatherDataService = WeatherDataService()
    
    private let key: String = "54ea5aafe4f56f20af6af65add"
    private let rootPath: String = "https://api.checkwx.com"
    private let defaultSession: URLSession = URLSession(configuration: URLSessionConfiguration.default)
    private let jsonDecoder = JSONDecoder()
    private let metarAccessQueue: DispatchQueue = DispatchQueue(label: "metar_access_queue")
    
    private var metarCache: [String : Metar] = [:]
    private var stationsChangedHandler: StationsChangedHandler?
    
    private(set) var lastKnownStations: Stations? {
        didSet{
            guard let s = lastKnownStations else { return }
            DispatchQueue.main.async { [weak self] in
                self?.stationsChangedHandler?(s)
            }
        }
    }
    
    public func register(update handler: @escaping StationsChangedHandler) {
        stationsChangedHandler = handler
    }
    
    public func update(nearAirportsBasedOn location: CLLocation) {
        airports(near: location) { [unowned self] (stations, error) in
            self.lastKnownStations = stations
        }
    }
    
    public func metar(for icao: String, wit completion: @escaping MetarInfoCompletion) {
        
        if let metar = get(metarFromCacheFor: icao) {
            completion(metar, nil)
            return
        }
        
        guard let url = create(metarURLFor: icao) else {
            completion(nil,nil)
            return
        }
        
        let request = generate(urlRequestFor: url)
        defaultSession.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let jsonData = data else {
                completion(nil, nil) // temp
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let results = try decoder.decode(Metars.self, from: jsonData)
                
                results.metars.forEach( {
                    self.cache(metar: $0)
                })
                
                completion(results.metars.first(where: { $0.icao == icao }), nil)
            } catch {
                dump(error)
                completion(nil, error)
            }
            
        }.resume()
        
    }
    
    public func airports(near location: CLLocation, with completion: @escaping NearbyAirportsCompletion) {
        
        guard let url = create(nearLocationURLFor: location) else {
            completion(nil, nil)
            return
        }
        
        let request = generate(urlRequestFor: url)
        defaultSession.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let jsonData = data else {
                completion(nil, nil) // temp
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                
                let stations = try decoder.decode(Stations.self, from: jsonData)
                completion(stations, nil)
            } catch {
                dump(error)
                completion(nil, error)
            }
            
        }.resume()
        
    }
    
    // MARK: Request Helpers
    
    private func get(metarFromCacheFor icao: String) -> Metar? {
        
        var value: Metar? = nil
        
        metarAccessQueue.sync {
            
            guard let metar = metarCache[icao] else {
                return
            }
            
            guard let metarDate = metar.date else {
                return
            }
            
            guard let agedDate = Calendar.current.date(byAdding: .minute, value: 15, to: metarDate) else {
                return
            }
            
            if agedDate < Date() {
                value = metar
            }
            
        }
        
        return value
    }
    
    private func cache(metar: Metar) {
        
        metarAccessQueue.async { [unowned self] in
            self.metarCache[metar.icao] = metar
        }
        
    }
    
    private func create(metarURLFor icao: String) -> URL? {
        return URL(string: "\(rootPath)/metar/\(icao)/decoded")
    }
    
    private func create(nearLocationURLFor location: CLLocation) -> URL? {
        return URL(string: "\(rootPath)/station/lat/\(location.coordinate.latitude)/lon/\(location.coordinate.longitude)/radius/25")
    }
    
    private func generate(urlRequestFor url: URL) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue(key, forHTTPHeaderField: "X-API-Key")
        return urlRequest
    }
    
}
