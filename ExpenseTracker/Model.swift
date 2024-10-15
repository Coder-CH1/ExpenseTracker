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
            createTableForExpenses()
        } catch {
            db = nil
            print("Unable to connect to database: \(error)")
        }
    }
    func createTableForExpenses() {
        let expenses = Table("expensess")
        do {
            try db!.run(expenses.create{ t in
            })
        } catch {
            print("Unable to create table: \(error)")
        }
    }
}
