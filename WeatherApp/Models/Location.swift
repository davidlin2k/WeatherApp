//
//  Location.swift
//  WeatherApp
//
//  Created by David Lin on 2023-02-20.
//

import CoreLocation
import Combine

enum LocationError: Error {
    case noPlacemark
}

class Location: NSObject, CLLocationManagerDelegate {
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var coord: CLLocationCoordinate2D? = nil
    @Published var city: String? = nil
    @Published var country: String? = nil
    
    var locationManager = CLLocationManager()
    
    static var geocoder = CLGeocoder()
    
    override init() {
        super.init()
        self.locationManager.delegate = self
    }
    
    init(coord: CLLocationCoordinate2D? = nil, city: String? = nil, country: String? = nil) {
        super.init()
        self.locationManager.delegate = self
        self.coord = coord
        self.city = city
        self.country = country
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
    
    func getCurrentLocation() -> CLLocationCoordinate2D? {
        self.locationManager.requestWhenInUseAuthorization()
        
        return self.locationManager.location?.coordinate
    }
    
    static func getLocationsByAddress(address: String) -> AnyPublisher<[Location], Error> {
        return Future<[Location], Error> { promise in
            geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
                if((error) != nil){
                    promise(.failure(error!))
                    return
                }
                
                guard let placemarks = placemarks else {
                    promise(.failure(LocationError.noPlacemark))
                    return
                }
                
                var locations: [Location] = []
                
                for placemark in placemarks {
                    if let location = placemark.location {
                        locations.append(Location(coord: location.coordinate, city: placemark.locality, country: placemark.country))
                    }
                }
                
                promise(.success(locations))
            })
        }.eraseToAnyPublisher()
    }
}
