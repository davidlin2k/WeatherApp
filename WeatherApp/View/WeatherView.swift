//
//  WeatherView.swift
//  WeatherApp
//
//  Created by David Lin on 2023-02-21.
//

import SwiftUI

struct WeatherView: View {
    var weather: Weather
    
    var body: some View {
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
    }
}
