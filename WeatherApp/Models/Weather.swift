//
//  Weather.swift
//  WeatherApp
//
//  Created by David Lin on 2023-02-20.
//

import CoreLocation

struct Weather {
    var temperature: Double
    var humidity: Int
    var windSpeed: Double
    var description: String
    var icon: String
    var location: Location?
}
