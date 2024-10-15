//
//  ExpenseViewController.swift
//  ExpenseTracker
//
//  Created by Mac on 15/10/2024.
//
import UIKit

class ExpensesViewController: UIViewController {
    
    let expensesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .lightGray
        tableView.register(ExpensesTableViewCell.self, forCellReuseIdentifier: "ExpensesTableViewCell")
        return tableView
    }()
    
    var expenses: [Expense] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        expensesTableView.dataSource = self
        expensesTableView.delegate = self
        setSubviewsAndLayout()
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
        
        let Addbtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addExpense))
        navigationItem.rightBarButtonItem = Addbtn
        navigationItem.rightBarButtonItem?.tintColor = .black
        
    }
    
    @objc func addExpense() {
        presentExpenseForm()
    }
    
    func loadExpense() {
        do {
            expenses = try DatabaseModel.shared.getAllExpense()
            expensesTableView.reloadData()
        } catch {
            print("Failed to load expenses: \(error)")
        }
    }
    
    func presentExpenseForm(expense: Expense? = nil) {
        let alert = UIAlertController(title: expense == nil ? "Add expense" :  "Update expense", message: "Enter details", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Description"
            textField.text = expense?.description
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Price"
            textField.keyboardType = .decimalPad
            textField.text = expense != nil ? String(expense!.price) : nil
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) {_ in
            guard let description = alert .textFields?[0].text, !description.isEmpty,
                  let priceText = alert.textFields?[1].text,
                  let price = Double(priceText) else { return }
            let newExpense = Expense(id: expense?.id,description: description, price: price, splitOption: "", receiptImage: nil)
            
            if let expense = expense {
                self.updateExpense(expense: newExpense)
            } else {
                self.saveExpense(expense: newExpense)
            }
        }
        
        alert.addAction(saveAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    func saveExpense(expense: Expense) {
        do {
            try DatabaseModel.shared.addExpense(expense)
            loadExpense()
        } catch {
            print("Failed to save expense: \(error)")
        }
    }
    
    func updateExpense(expense: Expense) {
        do {
            try DatabaseModel.shared.updateExpense(expense)
            loadExpense()
        } catch {
            print("Failed to update expense: \(error)")
        }
    }
    
    func deleteExpense(expense: Expense) {
        guard let expenseId = expense.id else { return }
        do {
            try DatabaseModel.shared.deleteExpense(id: expenseId)
            loadExpense()
        } catch {
            print("Failed to delete expense: \(error)")
        }
    }
}

extension ExpensesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpensesTableViewCell", for: indexPath) as! ExpensesTableViewCell
        let expense = expenses[indexPath.row]
        
        cell.descriptionLablel.text = expense.description
        cell.priceLablel.text = String(format: "$%.2f", expense.price)
        
        if let imageData = expense.receiptImage {
            cell.receiptImgView.image = UIImage(data: imageData)
        } else {
            cell.receiptImgView.image = nil
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
        expensesTableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //let expenseDeleteData = expenses[indexPath.row]
        let expense = expenses[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, view, completion in
            self.deleteExpense(expense: expense)
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

