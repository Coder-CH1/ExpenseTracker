//
//  Model.swift
//  ExpenseTracker
//
//  Created by Mac on 15/10/2024.
//

import Foundation
import sqlite3
import SQLite

struct Expense {
    var id: Int?
    var description: String
    var price: Double
    var splitOption: String
    var receiptImage: Data?
}

class DatabaseModel {
    static let shared = DatabaseModel()
    let db: Connection?
    //    let images = Table("images")
    //    let id = Expression<Int64>("id")
    //    let imageData = Expression<Data>("imageData")
    private init() {
        do {
            db = try
            Connection(.inMemory)
            createTableForUsers()
        } catch {
            db = nil
            print("Unable to connect to database: \(error)")
        }
    }
    func createTableForUsers() {
        let users = Table("users")
        let gender = Expression<String>("gender")
        do {
            try db!.run(users.create{ t in
                t.column(gender)
            })
        } catch {
            print("Unable to create table: \(error)")
        }
    }
    
    func saveGender(_ gender: String) {
        let users = Table("users")
        let genderColumn = Expression<String>("gender")
        do {
            try db?.run(users.insert(genderColumn <- gender))
        } catch {
            print("Unable to save gender: \(error)")
        }
    }
    
    func getUserGender() -> String? {
        let users = Table("users")
        let gender = Expression<String>("gender")
        do {
            if let user = try db?.pluck(users) {
                return try user.get(gender)
            } else {
                return nil
            }
        } catch {
            print("Unable to retrieve user gender\(error)")
            return nil
        }
    }
}
