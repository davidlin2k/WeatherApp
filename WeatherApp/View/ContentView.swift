//
//  ContentView.swift
//  WeatherApp
//
//  Created by David Lin on 2023-02-20.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var weather: Weather = Weather(temperature: 0, humidity: 0, windSpeed: 0, description: "", icon: "")
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Spacer()
                    Image(systemName: "door.left.hand.open")
                        .onTapGesture {
                            logout()
                        }
                }
                HStack {
                    AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(weather.icon)@2x.png")!) { phase in
                        if let image = phase.image {
                            image.resizable()
                                .frame(width: 150, height: 150)
                                .scaledToFill()
                        } else if phase.error != nil {
                            Color.clear
                                .frame(width: 150, height: 150)
                        } else {
                            ProgressView()
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("\(String(format: "%.1f", weather.temperature - 273.15)) °C")
                            .font(.system(size: 40.0, weight: .heavy))
                        
                        Text("\(weather.humidity) %")
                            .font(.system(size: 40.0, weight: .heavy))
                        
                        Text("\(String(format: "%.1f", weather.windSpeed)) km/h")
                            .font(.system(size: 40.0, weight: .heavy))
                        
                        Text("\(weather.description)")
        
                    }
                }
                
                Spacer()
                
                Button("Refresh") {
                    loadWeather()
                }
            }
        }
        .toolbar(.visible, for: .navigationBar)
        .padding()
        .task {
            loadWeather()
        }
    }
    
    func loadWeather() {
        let location = Location()
        
        location.coord = location.getLocation()
        self.weather.fetch(location: location)
    }
    
    func logout() {
        User.currentUser = nil
        dismiss()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
