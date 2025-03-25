//
//  ReportCell.swift
//  DemoRepord
//
//  Created by dan phi on 25/3/25.
//

import UIKit

class ReportCell: UITableViewCell {
    let reasonLabel = UILabel()
    let radioImageView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        radioImageView.image = UIImage(named: "dont-check")
        radioImageView.translatesAutoresizingMaskIntoConstraints = false
        radioImageView.contentMode = .scaleAspectFit
        
        reasonLabel.translatesAutoresizingMaskIntoConstraints = false
        reasonLabel.numberOfLines = 0
        
        contentView.addSubview(radioImageView)
        contentView.addSubview(reasonLabel)
        
        NSLayoutConstraint.activate([
            radioImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            radioImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            radioImageView.widthAnchor.constraint(equalToConstant: 24),
            radioImageView.heightAnchor.constraint(equalToConstant: 24),
            
            reasonLabel.leadingAnchor.constraint(equalTo: radioImageView.trailingAnchor, constant: 12),
            reasonLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            reasonLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            reasonLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
