//
//  AvatarView.swift
//  Streaming
//
//  Created by Dan Phi on 10/4/25.
//

import UIKit
import SDWebImage
class AvatarView: UIView {
    
    struct LayoutMetrics {
        static let imageSize: CGFloat = 36
        static let marginImage: CGFloat = 18
    }

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

            overlayImageView.widthAnchor.constraint(equalToConstant: 50),
            overlayImageView.heightAnchor.constraint(equalToConstant: 50),
            overlayImageView.centerXAnchor.constraint(equalTo: mainImageView.centerXAnchor, constant: LayoutMetrics.marginImage),
            overlayImageView.centerYAnchor.constraint(equalTo: mainImageView.centerYAnchor, constant: LayoutMetrics.marginImage)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        mainImageView.layer.cornerRadius = bounds.width / 2
        overlayImageView.layer.cornerRadius = overlayImageView.frame.width / 2
    }

    func configure(mainImage: String?, overlayImage: String?) {
        
        mainImageView.sd_setImage(with: convertStringToURL(urlString: mainImage ?? ""))

        if let overlay = overlayImage, !overlay.isEmpty {
            overlayImageView.isHidden = false
            overlayImageView.sd_setImage(with: convertStringToURL(urlString: overlay))
        } else {
            overlayImageView.isHidden = true
        }
    }
    
    func convertStringToURL(urlString: String) -> URL?{
        let url =  URL(string: urlString)
        
        return url
    }
}
