//
//  Weather.swift
//  WeatherApp
//
//  Created by David Lin on 2023-02-20.
//

import CoreLocation

class Weather: ObservableObject {
    private let weatherService = RealWeatherService()
    
    @Published var temperature: Double
    @Published var humidity: Int
    @Published var windSpeed: Double
    @Published var description: String
    @Published var icon: String
    
    init(temperature: Double, humidity: Int, windSpeed: Double, description: String, icon: String) {
        self.temperature = temperature
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.description = description
        self.icon = icon
    }
    
    func fetch(location: Location) {
        guard let coord = location.coord else {
            return
        }
        
        weatherService.getWeather(weather: self, lat: coord.latitude, lon: coord.longitude)
    }
}
