//
//  ShakeyBellView.swift
//  Bankey
//
//  Created by dan phi on 31/01/2025.
//

import UIKit

class ShakeyBellView: UIView {
    
    var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 48, height: 48)
    }
    
    func layout() {
        addSubview(imageView)
        translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let img = UIImage(named: "bell.fill")!.withTintColor(.white, renderingMode: .alwaysOriginal)
        imageView.image = img
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 24),
            imageView.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
}
