//
//  AccountSumaryCell.swift
//  Bankey
//
//  Created by dan phi on 27/01/2025.
//

import UIKit

class AccountSumaryCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static let reuseID = "AccountSumaryCell"
    static let rowHeight = 100 
    
    var typeLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.preferredFont(forTextStyle: .caption1)
        lb.adjustsFontForContentSizeCategory = true
        lb.text = "Account Type"
        return lb
    }()
    
    
    func setUp() {
        contentView.addSubview(typeLabel)
        
        NSLayoutConstraint.activate([
            typeLabel.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 2),
            typeLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2)
        ])
    }
}
