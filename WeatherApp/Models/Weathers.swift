//
//  Weathers.swift
//  WeatherApp
//
//  Created by David Lin on 2023-02-21.
//

import Foundation
import Combine

@MainActor
class Weathers: ObservableObject {
    @Published var currentWeather: Weather = Weather(temperature: 0, humidity: 0, windSpeed: 0, description: "", icon: "")
    @Published var weathers: [Weather] = []
    
    private var cancellables: Set<AnyCancellable> = []
    private let weatherService = RealWeatherService()
    
    static let shared: Weathers = Weathers()
    
    func fetchWeathersByAddress(address: String) {
        weathers.removeAll()
        
        Location.getLocationsByAddress(address: address)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }, receiveValue: { locations in
                for location in locations {
                    self.weatherService.getWeather(lat: location.coord!.latitude, lon: location.coord!.longitude)
                        .receive(on: RunLoop.main)
                        .sink(receiveCompletion: { completion in
                            switch completion {
                            case .finished:
                                break
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                        }, receiveValue: { weather in
                            let weatherWithAddress = Weather(temperature: weather.temperature, humidity: weather.humidity, windSpeed: weather.windSpeed, description: weather.description, icon: weather.icon, location: location)
                            
                            self.weathers.append(weatherWithAddress)
                        })
                        .store(in: &self.cancellables)
                }
            })
            .store(in: &cancellables)
    }
    
    func fetchCurrentWeather() {
        let location = Location()
        
        location.coord = location.getCurrentLocation()
        
        weatherService.getWeather(lat: location.coord!.latitude, lon: location.coord!.longitude)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }, receiveValue: { weather in
                self.currentWeather = weather
            })
            .store(in: &cancellables)
    }
}
