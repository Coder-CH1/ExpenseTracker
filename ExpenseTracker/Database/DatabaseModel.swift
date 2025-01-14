//
//  Model.swift
//  ExpenseTracker
//
//  Created by Mac on 15/10/2024.
//

import Foundation
import SQLite

// MARK: - Singleton Pattern Initialization and  Sqlite Table Creation -
class DatabaseModel {
    static let shared = DatabaseModel()
    let db: Connection?
    let expenses = Table("expenses")
    let id = Expression<Int>("id")
    let description = Expression<String>("description")
    let price = Expression<Double>("price")
    let splitOption = Expression<String>("split_option")
    let receiptImage = Expression<Data>("receipt_image")
    let isSaved = Expression<Bool>("is_saved")
    
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
                table.column(isSaved)
            })
            print("Table created successfully")
        } catch {
            print("Unable to create table: \(error)")
        }
    }
    
    func getSavedExpenses() throws -> [Expense] {
        var savedExpenses = [Expense]()
        do {
            let query = expenses.filter(isSaved == true)
            for expense in try db!.prepare(query) {
                savedExpenses.append(Expense(
                    id: expense[id],
                    description: expense[description],
                    price: expense[price],
                    splitOption: expense[splitOption],
                    receiptImage: expense[receiptImage],
                    isSaved: expense[isSaved]
                ))
            }
        } catch {
            print("Error fetching saved expenses: \(error)")
        }
        return savedExpenses
    }
    
    //MARK: - CRUD OPERATIONS -
    
    ///CREATE -
    func addExpense(_ expense: Expense) throws {
        let insert = expenses.insert(
            description <- expense.description,
            price <- expense.price,
            splitOption <- expense.splitOption,
            receiptImage <- (expense.receiptImage ?? Data()),
            isSaved <- (expense.isSaved)
        )
        try db!.run(insert)
    }
    
    
    ///READ -
    func getAllExpense() throws -> [Expense] {
        var list = [Expense]()
        do {
            for expense in try db!.prepare(expenses) {
                list.append(Expense(
                    id: expense[id],
                    description: expense[description],
                    price: expense[price],
                    splitOption: expense[splitOption],
                    receiptImage: expense[receiptImage],
                    isSaved: expense[isSaved]
                ))
            }
        } catch {
            print("error fetching expenses: \(error)")
            throw error
        }
        return list
    }
    
    ///UPDATE  -
    func updateExpense(_ expense: Expense) throws {
        guard let expenseId = expense.id else {return}
        let update = expenses.filter(expenseId == id)
        try db?.run(update.update(
            description <- expense.description,
            price <- expense.price,
            splitOption <- expense.splitOption,
            receiptImage <- (expense.receiptImage ?? Data())
        ))
    }
    
    ///DELETE  -
    func deleteExpense(id: Int) throws {
        let delete = expenses.filter(self.id == id)
        try db?.run(delete.delete())
    }
}
