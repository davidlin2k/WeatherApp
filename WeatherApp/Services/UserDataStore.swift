//
//  UserDataStore.swift
//  WeatherApp
//
//  Created by David Lin on 2023-02-20.
//

import Foundation
import SQLite

class UserDataStore {

    static let DIR_TASK_DB = "UserDB"
    static let STORE_NAME = "users.sqlite3"

    private let users = Table("users")

    private let id = Expression<Int64>("id")
    private let username = Expression<String>("username")
    private let passwordDigest = Expression<String>("password_digest")

    static let shared = UserDataStore()

    private var db: Connection? = nil

    private init() {
        if let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let dirPath = docDir.appendingPathComponent(Self.DIR_TASK_DB)

            do {
                try FileManager.default.createDirectory(atPath: dirPath.path, withIntermediateDirectories: true, attributes: nil)
                let dbPath = dirPath.appendingPathComponent(Self.STORE_NAME).path
                db = try Connection(dbPath)
                createTable()
                print("SQLiteDataStore init successfully at: \(dbPath) ")
            } catch {
                db = nil
                print("SQLiteDataStore init error: \(error)")
            }
        } else {
            db = nil
        }
    }

    private func createTable() {
        guard let database = db else {
            return
        }
        do {
            try database.run(users.create { table in
                table.column(id, primaryKey: .autoincrement)
                table.column(username, unique: true)
                table.column(passwordDigest)
            })
            print("Table Created...")
        } catch {
            print(error)
        }
    }
    
    func insert(username: String, password: String) -> Int64? {
        guard let database = db else { return nil }

        let insert = users.insert(self.username <- username,
                                  self.passwordDigest <- password)
        do {
            let rowID = try database.run(insert)
            return rowID
        } catch {
            print(error)
            return nil
        }
    }
    
    func findUser(searchUsername: String) -> User? {
        var user: User? = nil
        guard let database = db else { return nil }

        let filter = self.users.filter(username == searchUsername)
        do {
            for t in try database.prepare(filter) {
                user = User(username: "", passwordDigest: "")
                
                user?.username = t[username]
                user?.passwordDigest = t[passwordDigest]
            }
        } catch {
            print(error)
        }
        return user
    }
}
