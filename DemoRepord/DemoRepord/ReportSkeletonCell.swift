//
//  ReportSkeletonCell.swift
//  DemoRepord
//
//  Created by dan phi on 25/3/25.
//

import UIKit
import SkeletonView

class ReportSkeletonCell: UITableViewCell {
    private lazy var skeletonTextView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray.withAlphaComponent(0.3)
        view.layer.cornerRadius = 6
        
        view.isSkeletonable = true
        return view
    }()
    
    private lazy var skeletonRadioView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray.withAlphaComponent(0.3)
        view.layer.cornerRadius = view.frame.width / 2// Bo tròn (giống icon)
        view.clipsToBounds = true
        view.isSkeletonable = true
        return view
    }()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Enable skeleton loading
        isSkeletonable = true
        contentView.isSkeletonable = true

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
