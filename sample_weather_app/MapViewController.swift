//
//  ViewController.swift
//  sample_weather_app
//
//  Created by Konrad Winkowski on 4/28/18.
//  Copyright © 2018 Konrad Winkowski. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    private let locationService: LocationService = LocationService.service
    private let weatherService: WeatherDataService = WeatherDataService.service
    
    private var previousAnnotations: [MKAnnotation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: K.MapViewAnnotation.airportAnnotation)
        registerForNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard locationService.isAuthorized else {
            locationService.requestLocationUsage()
            return
        }
        
        setupMapView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: UI Updates
    
    private func update(mapAnnotationsWith stations: Stations) {
       
        mapView.removeAnnotations(previousAnnotations)
        
        let annotations = stations.airports.map({ AirportAnnotation(with: $0) })
        previousAnnotations = annotations
        mapView.addAnnotations(previousAnnotations)
        
    }
    
    // MARK: Helpers
    
    private func registerForWeatherDataUpdates() {
        
        weatherService.register { [weak self] (stations) in
            self?.update(mapAnnotationsWith: stations)
        }
        
    }
    
    @objc private func setupMapView() {
        
        guard locationService.isAuthorized else { return }
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        registerForWeatherDataUpdates()
        
    }
    
    // MARK: Notifications

    private func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(setupMapView), name: WeatherAppNotifications.LocationServices.authorizationStatusNotification, object: nil)
    }
    
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let airportAnnotation = annotation as? AirportAnnotation else { return nil }
        
        var annotationView: MKAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: K.MapViewAnnotation.airportAnnotation, for: airportAnnotation)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: airportAnnotation, reuseIdentifier: K.MapViewAnnotation.airportAnnotation)
        }
        
        annotationView?.image = UIImage(named: "icon_airport")
        annotationView?.annotation = airportAnnotation
        annotationView?.canShowCallout = true
        
        return annotationView
    
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let airportAnnotation = view.annotation as? AirportAnnotation else {
            return
        }
        
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: K.ViewController.airportDetailViewController) as? AirportDetailViewController else {
            return
        }
        
        vc.station = airportAnnotation.station
        present(vc, animated: true, completion: nil)
        
    }
    
}

