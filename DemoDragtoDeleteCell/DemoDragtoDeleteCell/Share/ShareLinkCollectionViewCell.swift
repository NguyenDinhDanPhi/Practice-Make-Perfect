
//
//  ShareCollectionViewCell.swift
//  Streaming
//
//  Created by dan phi on 26/3/25.
//
import UIKit

class ShareLinkCollectionViewCell: UICollectionViewCell {
    static let identifier = "ShareLinkCollectionViewCell"
    
    struct LayoutMetrics {
        let iconSize: CGFloat
        let iconTopPadding: CGFloat
        let titleTopPadding: CGFloat
        let titleMaxWidth: CGFloat
        
        static let `default` = LayoutMetrics(
            iconSize: 40,
            iconTopPadding: 5,
            titleTopPadding: 6,
            titleMaxWidth: 50
        )
    }
    
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 20
        iv.clipsToBounds = true
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .black
        return label
    }()
    
    var metrics: LayoutMetrics
    
    override init(frame: CGRect) {
        self.metrics = LayoutMetrics.default
        super.init(frame: frame)
        setupViews()
        
    }
    
    private func setupViews() {
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: metrics.iconTopPadding),
            iconImageView.widthAnchor.constraint(equalToConstant: metrics.iconSize),
            iconImageView.heightAnchor.constraint(equalToConstant: metrics.iconSize),
            
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: metrics.titleTopPadding),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.widthAnchor.constraint(lessThanOrEqualToConstant: metrics.titleMaxWidth)        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with item: SocialNetworkSharing) {
        iconImageView.image = item.icon
        titleLabel.text = item.title
    }
}
