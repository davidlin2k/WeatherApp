//
//  Location.swift
//  WeatherApp
//
//  Created by David Lin on 2023-02-20.
//

import CoreLocation

class Location: NSObject, CLLocationManagerDelegate {
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var coord: CLLocationCoordinate2D?
    
    var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            authorizationStatus = .authorizedWhenInUse
            break
        case .restricted:
            authorizationStatus = .restricted
            break
        case .denied:
            authorizationStatus = .denied
            break
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            break
        default:
            break
        }
    }
    
    func getLocation() -> CLLocationCoordinate2D? {
        self.locationManager.requestWhenInUseAuthorization()
        
        return self.locationManager.location?.coordinate
    }
}
