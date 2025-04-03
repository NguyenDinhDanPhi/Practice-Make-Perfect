//
//  AvatarView.swift
//  DemoNotification
//
//  Created by dan phi on 3/4/25.
//


import UIKit

class AvatarView: UIView {

    private let mainImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let overlayImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 2
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isHidden = true
        return iv
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        addSubview(mainImageView)
        addSubview(overlayImageView)

        NSLayoutConstraint.activate([
            mainImageView.topAnchor.constraint(equalTo: topAnchor),
            mainImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainImageView.bottomAnchor.constraint(equalTo: bottomAnchor),

            overlayImageView.widthAnchor.constraint(equalToConstant: 36),
            overlayImageView.heightAnchor.constraint(equalToConstant: 36),
            overlayImageView.centerXAnchor.constraint(equalTo: mainImageView.centerXAnchor, constant: 18),
            overlayImageView.centerYAnchor.constraint(equalTo: mainImageView.centerYAnchor, constant: 18)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        mainImageView.layer.cornerRadius = bounds.width / 2
        overlayImageView.layer.cornerRadius = overlayImageView.frame.width / 2
    }

    // MARK: - Public API

    func configure(mainImage: UIImage?, overlayImage: UIImage?) {
        mainImageView.image = mainImage

        if let overlay = overlayImage {
            overlayImageView.isHidden = false
            overlayImageView.image = overlay
        } else {
            overlayImageView.isHidden = true
        }
    }
}
