//
//  WeatherService.swift
//  WeatherApp
//
//  Created by David Lin on 2023-02-20.
//

import Alamofire
import SwiftUI
import Combine

struct WeatherResponse: Decodable {
    let coordinates: Coordinates
    let weather: [WeatherInfo]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let datetime: Date
    let system: System
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int

    enum CodingKeys: String, CodingKey {
        case coordinates = "coord"
        case weather
        case base
        case main
        case visibility
        case wind
        case clouds
        case datetime = "dt"
        case system = "sys"
        case timezone
        case id
        case name
        case cod
    }
}

struct Coordinates: Decodable {
    let longitude: Double
    let latitude: Double

    enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
}

struct WeatherInfo: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Main: Decodable {
    let temperature: Double
    let feelsLike: Double
    let temperatureMin: Double
    let temperatureMax: Double
    let pressure: Int
    let humidity: Int

    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case feelsLike = "feels_like"
        case temperatureMin = "temp_min"
        case temperatureMax = "temp_max"
        case pressure
        case humidity
    }
}

struct Wind: Decodable {
    let speed: Double
    let degree: Int

    enum CodingKeys: String, CodingKey {
        case speed
        case degree = "deg"
    }
}

struct Clouds: Decodable {
    let all: Int
}

struct System: Decodable {
    let type: Int
    let id: Int
    let country: String
    let sunrise: Date
    let sunset: Date

    enum CodingKeys: String, CodingKey {
        case type
        case id
        case country
        case sunrise
        case sunset
    }
}

protocol WeatherService {
    
}

class RealWeatherService: WeatherService {
    func getWeather(lat: Double, lon: Double) -> AnyPublisher<Weather, Error> {
        var apiKey = ""
        
        if let path = Bundle.main.path(forResource: "API Keys", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) as? [String: Any] {
           apiKey = dict["WEATHER_API_KEY"] as? String ?? ""
        }
        
        let endpoint = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)"

        return Future<Weather, Error> { promise in
            
            AF.request(endpoint).responseDecodable(of: WeatherResponse.self) { response in
                switch response.result {
                case .success(let weatherResponse):
                    let weather = Weather(temperature: weatherResponse.main.temperature, humidity: weatherResponse.main.humidity, windSpeed: weatherResponse.wind.speed, description: weatherResponse.weather[0].description.capitalized, icon: weatherResponse.weather[0].icon)

                    promise(.success(weather))
                    
                    print("Received weather data for timezone: \(weatherResponse.timezone)")
                    print("Temperature: \(weatherResponse.main.temperature)K")

                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }.eraseToAnyPublisher()
    }
}
