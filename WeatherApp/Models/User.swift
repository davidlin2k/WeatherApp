//
//  User.swift
//  WeatherApp
//
//  Created by David Lin on 2023-02-20.
//

import Foundation

class User {
    var username: String
    var passwordDigest: String
    
    static var currentUser: User?
    
    init(username: String, passwordDigest: String) {
        self.username = username
        self.passwordDigest = passwordDigest
    }
    
    static func findBy(username: String) -> User? {
        return SQLiteUserService.shared.findUser(username: username)
    }
    
    func authenticate(password: String) -> Bool {
        return true
    }
}
