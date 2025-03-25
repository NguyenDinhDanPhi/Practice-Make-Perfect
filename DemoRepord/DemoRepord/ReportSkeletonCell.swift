//
//  ReportSkeletonCell.swift
//  DemoRepord
//
//  Created by dan phi on 25/3/25.
//

import UIKit

class ReportSkeletonCell: UITableViewCell {
    let skeletonTextView = UIView()
    let skeletonRadioView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Thiết lập skeleton cho radio button
        skeletonRadioView.translatesAutoresizingMaskIntoConstraints = false
        skeletonRadioView.backgroundColor = .lightGray.withAlphaComponent(0.3)
        skeletonRadioView.layer.cornerRadius = 12 // Bo tròn (giống icon)
        
        // Thiết lập skeleton cho text label
        skeletonTextView.translatesAutoresizingMaskIntoConstraints = false
        skeletonTextView.backgroundColor = .lightGray.withAlphaComponent(0.3)
        skeletonTextView.layer.cornerRadius = 6
        
        contentView.addSubview(skeletonRadioView)
        contentView.addSubview(skeletonTextView)
        
        NSLayoutConstraint.activate([
            skeletonRadioView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            skeletonRadioView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            skeletonRadioView.widthAnchor.constraint(equalToConstant: 24),
            skeletonRadioView.heightAnchor.constraint(equalToConstant: 24),
            
            skeletonTextView.leadingAnchor.constraint(equalTo: skeletonRadioView.trailingAnchor, constant: 12),
            skeletonTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            skeletonTextView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            skeletonTextView.heightAnchor.constraint(equalToConstant: 16)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
