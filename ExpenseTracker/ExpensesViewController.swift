//
//  ExpenseViewController.swift
//  ExpenseTracker
//
//  Created by Mac on 15/10/2024.
//
import UIKit

//MARK: - UI
class ExpensesViewController: UIViewController {
    
    // MARK: - Objects -
    let expensesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ExpensesTableViewCell.self, forCellReuseIdentifier: "ExpensesTableViewCell")
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    var expenses: [Expense] = []
    let imagePicker = UIImagePickerController()
    var selectedImageData: Data?
    var currentAlert: UIAlertController?
    let segmentedControl = UISegmentedControl(items: ["Current", "Saved"])
    
    // MARK: - Life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedChanged), for: .valueChanged)
        navigationItem.titleView = segmentedControl
        setSubviewsAndLayout()
    }
    
    @objc func segmentedChanged() {
        if segmentedControl.selectedSegmentIndex == 0 {
            loadCurrentExpense()
        } else {
            savedExpenses()
        }
    }
    
    // MARK: - Subviews and Layout -
    func setSubviewsAndLayout() {
        expensesTableView.delegate = self
        expensesTableView.dataSource = self
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
    
    // MARK: - Method to add expenses -
    @objc func addExpense() {
        presentExpenseForm()
    }
    
    // MARK: - Method to load expenses -
    func loadCurrentExpense() {
        do {
            expenses = try DatabaseModel.shared.getAllExpense()
            DispatchQueue.main.async {
                self.expensesTableView.reloadData()
            }
        } catch {
            print("Failed to load expenses: \(error)")
        }
    }
    
    func savedExpenses() {
        do {
            expenses = try DatabaseModel.shared.getSavedExpenses()
            DispatchQueue.main.async {
                self.expensesTableView.reloadData()
            }
        } catch {
            print("Failed to load saved expenses: \(error)")
        }
    }
    
    // MARK: - Method to present alert form expenses -
    func presentExpenseForm(expense: Expense? = nil) {
        currentAlert = UIAlertController(title: expense == nil ? "Add expense" :  "Update expense", message: "Enter details", preferredStyle: .alert)
        
        currentAlert?.addTextField { textField in
            textField.placeholder = "Description"
            textField.text = expense?.description
        }
        
        currentAlert?.addTextField { textField in
            textField.placeholder = "Price"
            textField.keyboardType = .decimalPad
            textField.text = expense != nil ? String(expense!.price) : nil
        }
        
        let uploadImage = UIAlertAction(title: "Upload receipt", style: .default) {_ in
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true)
        }
        
        currentAlert?.addAction(uploadImage)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) {_ in
            guard let description = self.currentAlert?.textFields?[0].text, !description.isEmpty,
                  let priceText = self.currentAlert?.textFields?[1].text,
                  let price = Double(priceText) else { return }
            let newExpense = Expense(id: expense?.id,description: description, price: price, splitOption: "", receiptImage: self.selectedImageData)
            
            if expense != nil {
                self.updateExpense(expense: newExpense)
            } else {
                self.saveExpense(expense: newExpense)
            }
        }
        
        currentAlert?.addAction(saveAction)
        currentAlert?.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(currentAlert!, animated: true)
    }
    
    // MARK: - Method to save expenses -
    func saveExpense(expense: Expense) {
        var savedExpense = expense
        savedExpense.isSaved = true
        do {
            try DatabaseModel.shared.addExpense(expense)
            loadCurrentExpense()
            savedExpenses()
        } catch {
            print("Failed to save expense: \(error)")
        }
    }
    
    // MARK: - Method to update expenses -
    func updateExpense(expense: Expense) {
        do {
            try DatabaseModel.shared.updateExpense(expense)
            loadCurrentExpense()
        } catch {
            print("Failed to update expense: \(error)")
        }
    }
    
    // MARK: - Method to delete expenses -
    func deleteExpense(expense: Expense) {
        guard let expenseId = expense.id else { return }
        do {
            try DatabaseModel.shared.deleteExpense(id: expenseId)
            loadCurrentExpense()
        } catch {
            print("Failed to delete expense: \(error)")
        }
    }
}

// MARK: - Extensions for protocol datasource and delegate -
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
        let expense = expenses[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, view, completion in
            self.deleteExpense(expense: expense)
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

// MARK: - Protocol delegate for Image picker
extension ExpensesViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImageData = image.pngData()
            currentAlert?.message = "image selected"
        }
        picker.dismiss(animated: true) {
            if let currentAlert = self.currentAlert {
                self.present(currentAlert, animated: true)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
