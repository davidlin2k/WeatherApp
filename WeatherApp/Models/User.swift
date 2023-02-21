//
//  User.swift
//  WeatherApp
//
//  Created by David Lin on 2023-02-20.
//

import Foundation

class User {
    private let username: String
    private let passwordDigest: String
    
    static var currentUser: User?
    
    init(username: String, passwordDigest: String) {
        self.username = username
        self.passwordDigest = passwordDigest
    }
    
    func findBy(username: String) {
        // Database operations
    }
    
    func authenticate(password: String) -> Bool {
        return true
    }
}
