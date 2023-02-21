//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by David Lin on 2023-02-20.
//

import SwiftUI

@main
struct WeatherAppApp: App {
    
    @StateObject var launchState = LaunchStateManager()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                
                if launchState.state != .finished {
                    LaunchView()
                }
            }.environmentObject(launchState)
        }
    }
}
