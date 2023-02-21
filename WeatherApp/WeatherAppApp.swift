//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by David Lin on 2023-02-20.
//

import SwiftUI

@main
struct WeatherAppApp: App {
    @StateObject var userService = SQLiteUserService()
    @StateObject var launchState = LaunchStateManager()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                LoginView()
                
                if launchState.state != .finished {
                    LaunchView()
                }
            }
            .environmentObject(launchState)
            .environmentObject(userService)
        }
    }
}
