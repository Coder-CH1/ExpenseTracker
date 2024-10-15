//
//  ExpenseViewController.swift
//  ExpenseTracker
//
//  Created by Mac on 15/10/2024.
//

import UIKit

class ExpensesViewController: UIViewController {
    
    lazy var expensesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        //tableView.backgroundColor = .lightGray
        tableView.register(ExpensesTableViewCell.self, forCellReuseIdentifier: "ExpensesTableViewCell")
        return tableView
    }()
    
    var expenses: [Expense] = []

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Subviews and Layout -
    func setSubviewsAndLayout() {
        view.addSubview(expensesTableView)
        NSLayoutConstraint.activate([
            expensesTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            expensesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14),
            expensesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14),
            expensesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
        ])
    }
    
    func loadExpenses() {
        do {
            expenses = try DatabaseModel.shared.getAllExpenses()
            expensesTableView.reloadData()
        } catch {
           print("failed to load expenses: \(error)")
        }
    }
    
}

extension ExpensesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpensesTableViewCell", for: indexPath) as! ExpensesTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        expensesTableView.deselectRow(at: indexPath, animated: true)
        
    }
}
