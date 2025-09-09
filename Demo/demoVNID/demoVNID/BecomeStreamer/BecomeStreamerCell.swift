//
//  VerifyItemCell.swift
//  demoVNID
//
//  Created by Dan Phi on 9/9/25.
//

import UIKit

// MARK: - Model
struct VerifyItem {
    let icon: UIImage?
    let title: String
    enum Accessory {
        case checkmarkGreen
        case statusPill(text: String, bg: UIColor, textColor: UIColor, showChevron: Bool)
        case none
    }
    let accessory: Accessory
}

// MARK: - Cell
final class BecomeStreamerCell: UITableViewCell {
    static let reuseID = "VerifyItemCell"
    
    private lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let checkView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "checkmark"))
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .systemGreen
        
        return view
    }()

    private lazy var statusLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 11, weight: .medium)
        label.textColor = .white
        label.backgroundColor = .systemRed
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        label.textAlignment = .center
        
        return label
    }()
    
    private let chevronView: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "chevron.right"))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .tertiaryLabel
        return view
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(
            by: UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16)
        )
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = UIColor.systemGray6
    }
    
    private func setupViews() {
        selectionStyle = .none
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(checkView)
        contentView.addSubview(statusLabel)
        contentView.addSubview(chevronView)
        
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            chevronView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            chevronView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            statusLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: chevronView.leadingAnchor, constant: -8),
            
            checkView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            iconView.widthAnchor.constraint(equalToConstant: 32),
            iconView.heightAnchor.constraint(equalToConstant: 32),
            
            checkView.widthAnchor.constraint(equalToConstant: 24),
            checkView.heightAnchor.constraint(equalToConstant: 24),
            
            chevronView.widthAnchor.constraint(equalToConstant: 10)
        ])
    }
    
    
    func configure(with item: VerifyItem) {
        iconView.image = item.icon
        titleLabel.text = item.title
        
        checkView.isHidden = true
        statusLabel.isHidden = true
        chevronView.isHidden = true
        
        switch item.accessory {
        case .checkmarkGreen:
            checkView.isHidden = false
        case .statusPill(let text, let bg, let textColor, let showChevron):
            statusLabel.isHidden = false
            statusLabel.text = text
            statusLabel.backgroundColor = bg
            statusLabel.textColor = textColor
            chevronView.isHidden = !showChevron
        case .none:
            break
        }
    }
}
