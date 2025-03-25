//
//  ShareCollectionViewCell.swift
//  DemoURLScheme
//
//  Created by dan phi on 25/3/25.
//
import UIKit

struct ShareItem {
    let icon: UIImage?
    let title: String
    let action: () -> Void  // Closure để gọi hành động khi nhấn vào
}

import UIKit

class ShareCollectionViewCell: UICollectionViewCell {
    static let identifier = "ShareCollectionViewCell"
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 20  // Giảm kích thước bo tròn
        iv.clipsToBounds = true
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 10) // Giảm font chữ
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            iconImageView.widthAnchor.constraint(equalToConstant: 40),  // Giảm kích thước icon
            iconImageView.heightAnchor.constraint(equalToConstant: 40), // Giảm kích thước icon
            
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 2),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 50) // Giới hạn text không bị tràn
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with item: ShareItem) {
        iconImageView.image = item.icon
        titleLabel.text = item.title
    }
}
