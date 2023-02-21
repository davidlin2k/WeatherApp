//
//  UserServices.swift
//  WeatherApp
//
//  Created by David Lin on 2023-02-20.
//

import SwiftUI

protocol UserService {
    func createUser(username: String, password: String) -> Bool
    func findUser(username: String) -> User?
}

class SQLiteUserService: UserService, ObservableObject {
    static var shared: UserService = SQLiteUserService()
    
    func createUser(username: String, password: String) -> Bool {
        let userId = UserDataStore.shared.insert(username: username, password: password)
        
        return userId != nil
    }
    
    func findUser(username: String) -> User? {
        return UserDataStore.shared.findUser(searchUsername: username)
    }
}
