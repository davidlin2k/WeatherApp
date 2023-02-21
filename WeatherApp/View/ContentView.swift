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
    
    @StateObject private var weathers: Weathers = Weathers()
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Image(systemName: "arrow.clockwise")
                        .onTapGesture {
                            loadWeather()
                        }
                    
                    Spacer()
                    
                    Image(systemName: "door.left.hand.open")
                        .onTapGesture {
                            logout()
                        }
                }
                HStack {
                    AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(weathers.currentWeather.icon)@2x.png")!) { phase in
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
                        Text("\(String(format: "%.1f", weathers.currentWeather.temperature - 273.15)) °C")
                            .font(.system(size: 40.0, weight: .heavy))
                        
                        Text("\(weathers.currentWeather.humidity) %")
                            .font(.system(size: 40.0, weight: .heavy))
                        
                        Text("\(String(format: "%.1f", weathers.currentWeather.windSpeed)) km/h")
                            .font(.system(size: 40.0, weight: .heavy))
                        
                        Text("\(weathers.currentWeather.description)")
        
                    }
                }
                
                List {
                    ForEach(weathers.weathers, id: \.self.location) { weatherResult in
                        HStack {
                            AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(weathers.currentWeather.icon)@2x.png")!) { phase in
                                if let image = phase.image {
                                    image.resizable()
                                        .frame(width: 50, height: 50)
                                        .scaledToFill()
                                } else if phase.error != nil {
                                    Color.clear
                                        .frame(width: 50, height: 50)
                                } else {
                                    ProgressView()
                                }
                            }
                            
                            Spacer()
                            
                            Text("\(String(format: "%.1f", weatherResult.temperature - 273.15)) °C")
                                .font(.system(size: 40.0, weight: .heavy))
                        }
                    }
                }
                
                Spacer()
                
                Button("Search") {
                    weathers.fetchWeathersByAddress(address: "Waterloo")
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
        self.weathers.fetchCurrentWeather()
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
