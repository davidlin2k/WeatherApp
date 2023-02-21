//
//  Weather.swift
//  WeatherApp
//
//  Created by David Lin on 2023-02-20.
//

import CoreLocation

class Weather: ObservableObject {
    var temperature: Double
    var humidity: Double
    var windSpeed: Double
    var description: String
    
    init(temperature: Double, humidity: Double, windSpeed: Double, description: String) {
        self.temperature = temperature
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.description = description
    }
}
