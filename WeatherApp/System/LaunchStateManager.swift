//
//  LaunchStateManager.swift
//  WeatherApp
//
//  Created by David Lin on 2023-02-20.
//

import Foundation

final class LaunchStateManager: ObservableObject {
    
    @MainActor @Published private(set) var state: LaunchState = .firstStep
    
    @MainActor func dismiss() {
        Task {
            self.state = .secondStep

            try? await Task.sleep(for: Duration.seconds(1))

            self.state = .finished
        }
    }
}
