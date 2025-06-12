//
//  DropdownCell.swift
//  DemoDragtoDeleteCell
//
//  Created by dan phi on 1/4/25.
//

import UIKit

class DropdownCell: UITableViewCell {
    
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let checkmarkImageView = UIImageView()

    private let spacerView = UIView() // giữ chỗ cho checkmark

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        iconImageView.tintColor = .black
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true

        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.textColor = .black

        checkmarkImageView.image = UIImage(systemName: "checkmark")
        checkmarkImageView.tintColor = .black
        checkmarkImageView.contentMode = .scaleAspectFit
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        checkmarkImageView.widthAnchor.constraint(equalToConstant: 18).isActive = true
        checkmarkImageView.heightAnchor.constraint(equalToConstant: 18).isActive = true

        spacerView.translatesAutoresizingMaskIntoConstraints = false
        spacerView.widthAnchor.constraint(equalToConstant: 18).isActive = true // giữ chỗ khi không có tick

        let hStack = UIStackView(arrangedSubviews: [iconImageView, titleLabel, spacerView])
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.spacing = 12

        let wrapper = UIStackView(arrangedSubviews: [hStack, checkmarkImageView])
        wrapper.axis = .horizontal
        wrapper.alignment = .center
        wrapper.distribution = .equalSpacing

        contentView.addSubview(wrapper)
        wrapper.translatesAutoresizingMaskIntoConstraints = false
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
        spacerView.isHidden = selected // nếu có tick thì spacer ẩn, nếu không thì hiện để giữ chỗ
    }
}
