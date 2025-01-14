//
//  Model.swift
//  ExpenseTracker
//
//  Created by Mac on 16/10/2024.
//

import Foundation

// MARK: - Data Model -
struct Expense {
    var id: Int?
    var description: String
    var price: Double
    var splitOption: String
    var receiptImage: Data?
    var isSaved: Bool = false
}
