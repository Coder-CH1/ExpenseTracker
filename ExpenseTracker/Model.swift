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
    let expenses = Table("expenses")
    let id = Expression<Int>("id")
    let description = Expression<String>("description")
    let price = Expression<Double>("price")
    let splitOption = Expression<String>("split_option")
    let receiptImage = Expression<Data>("receipt_image")
    private init() {
        do {
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let dbPath = documentDirectory.appendingPathComponent("expenses.sqlite3").path
            db = try
            Connection(dbPath)
            createTableForExpenses()
        } catch {
            db = nil
            print("Unable to connect to database: \(error)")
        }
    }
    func createTableForExpenses() {
        do {
            try db!.run(expenses.create(ifNotExists: true){ table in
                table.column(id, primaryKey: .autoincrement)
                table.column(description)
                table.column(price)
                table.column(splitOption)
                table.column(receiptImage)
            })
        } catch {
            print("Unable to create table: \(error)")
        }
    }
    
    func getAllExpenses() throws -> [Expense] {
        var list = [Expense]()
        do {
            for expense in try db!.prepare(expenses) {
                list.append(Expense(
                    id: expense[id],
                    description: expense[description],
                    price: expense[price],
                    splitOption: expense[splitOption],
                receiptImage: expense[receiptImage]
                ))
            }
        } catch {
            print("error fetching expenses: \(error)")
            throw error
        }
        return list
    }
}
