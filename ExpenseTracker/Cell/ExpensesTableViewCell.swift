//
//  ExpensesTableViewCell.swift
//  ExpenseTracker
//
//  Created by Mac on 15/10/2024.
//

import UIKit

// MARK: - UI -
class ExpensesTableViewCell: UITableViewCell {
    
    // MARK: - Objects -
    let descriptionLablel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let priceLablel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let receiptImgView: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let identifier = "ExpensesTableViewCell"
    
    // MARK: - Life cycle -
    override func awakeFromNib() {
        super.awakeFromNib()
        setSubviewsAndLayout()
    }
    
    // MARK: - Life cycle -
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setSubviewsAndLayout()
    }
    
    // MARK: - Subviews and Layout -
    func setSubviewsAndLayout() {
        addSubview(descriptionLablel)
        addSubview(priceLablel)
        addSubview(receiptImgView)
        NSLayoutConstraint.activate([
            receiptImgView.heightAnchor.constraint(equalToConstant: 100),
            receiptImgView.widthAnchor.constraint(equalToConstant: 100),
            receiptImgView.topAnchor.constraint(equalTo: self.topAnchor),
            receiptImgView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            descriptionLablel.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
            descriptionLablel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            
            priceLablel.topAnchor.constraint(equalTo: descriptionLablel.bottomAnchor, constant: 10),
            priceLablel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
        ])
    }
}
