//
//  ExpensesTableViewCell.swift
//  ExpenseTracker
//
//  Created by Mac on 15/10/2024.
//

import UIKit

class ExpensesTableViewCell: UITableViewCell {
    
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

    override func awakeFromNib() {
        super.awakeFromNib()
        setSubviewsAndLayout()
    }

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
            receiptImgView.topAnchor.constraint(equalTo: self.topAnchor),
            receiptImgView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            descriptionLablel.topAnchor.constraint(equalTo: self.topAnchor),
            descriptionLablel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            
            priceLablel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
    }

}
