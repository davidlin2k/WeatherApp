//
//  ContentView.swift
//  WeatherApp
//
//  Created by David Lin on 2023-02-20.
//

import SwiftUI
import CoreLocation
import UserNotifications

struct ContentView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var weathers: Weathers = Weathers()
    
    @State private var searchText: String = ""
    @State private var showDetail: Bool = false
    @State private var selectedWeather: Weather? = nil
    
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
                
                WeatherView(weather: weathers.currentWeather)
                
                List {
                    ForEach(weathers.weathers, id: \.self.location) { weatherResult in
                        HStack {
                            VStack(alignment: .leading, spacing: 0) {
                                Text(weatherResult.location?.city ?? "")
                                    .font(.system(size: 15.0, weight: .heavy))
                                
                                AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(weatherResult.icon)@2x.png")!) { phase in
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
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing) {
                                Text("\(String(format: "%.1f", weatherResult.temperature - 273.15)) °C")
                                    .font(.system(size: 30.0, weight: .heavy))
                                
                                Text("\(weatherResult.description)")
                                    .font(.system(size: 14.0, weight: .heavy))
                                Spacer()
                            }
                        }
                        .listRowBackground(Color.gray)
                        .onTapGesture {
                            self.selectedWeather = weatherResult
                            showDetail = true
                        }
                    }
                }
                .background(.clear)
                .scrollContentBackground(.hidden)
                
                Spacer()
                
                HStack {
                    TextField("Address", text: $searchText)
                    Spacer()
                    Button("Search") {
                        weathers.fetchWeathersByAddress(address: searchText)
                    }
                }
                
            }
        }
        .toolbar(.visible, for: .navigationBar)
        .padding()
        .sheet(item: self.$selectedWeather) { weather in
            VStack {
                
                Text(weather.location?.country ?? "")
                    .font(.system(size: 40.0, weight: .heavy))
                Text(weather.location?.city ?? "")
                    .font(.system(size: 40.0, weight: .heavy))
                
                WeatherView(weather: weather)
            }
            .padding()
        }
        .task {
            loadWeather()
            
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if let error = error {
                    print(error)
                }
                
                scheduleLocalNotification()
            }
        }
    }
    
    func scheduleLocalNotification() {
        let notificationAlreadyScheduled = UserDefaults.standard.bool(forKey: "notificationAlreadyScheduled")
        guard !notificationAlreadyScheduled else {
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Weather Time"
        content.body = "Time to check the weather of the day"
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 8
        dateComponents.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: "daily_notification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling local notification: \(error.localizedDescription)")
            } else {
                print("Local notification scheduled successfully")
                UserDefaults.standard.set(true, forKey: "notificationAlreadyScheduled")
            }
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
