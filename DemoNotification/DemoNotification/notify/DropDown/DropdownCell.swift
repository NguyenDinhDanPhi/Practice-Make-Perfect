
//
//  DropdownCell.swift
//  DemoDragtoDeleteCell
//
//  Created by dan phi on 1/4/25.
//

import UIKit

class DropdownCell: UITableViewCell {
    
    private lazy var iconImageView: UIImageView = {
        let img = UIImageView()
        img.tintColor = .black
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private let checkmarkImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "checkmark")
        img.tintColor = .black
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        
        return img
    }()
    
    private let spacerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    private lazy var hStack : UIStackView  = {
        let stack = UIStackView(arrangedSubviews: [iconImageView, titleLabel, spacerView])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 12
        return stack
    }()
    
    private lazy var wrapper: UIStackView =  {
        let stack = UIStackView(arrangedSubviews: [hStack, checkmarkImageView])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false

        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 24),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 24),
            
            spacerView.widthAnchor.constraint(equalToConstant: 18)
        ])
        
        contentView.addSubview(wrapper)
        NSLayoutConstraint.activate([
            wrapper.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            wrapper.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            wrapper.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            wrapper.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(title: String, iconName: String, selected: Bool) {
        titleLabel.text = title
        iconImageView.image = UIImage(systemName: iconName)
        checkmarkImageView.isHidden = !selected
        spacerView.isHidden = selected
    }
}
