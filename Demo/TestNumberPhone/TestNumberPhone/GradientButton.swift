//
//  GradientButton.swift
//  TestNumberPhone
//
//  Created by Dan Phi on 3/10/25.
//

import UIKit
// MARK: - GradientButton
final class GradientButton: UIButton {
    private let gradientLayer = CAGradientLayer()
    
    override var isEnabled: Bool {
        didSet { updateStyle() }
    }
    
    override init(frame: CGRect) { super.init(frame: frame); setupGradient() }
    required init?(coder: NSCoder) { super.init(coder: coder); setupGradient() }
    
    private func setupGradient() {
        gradientLayer.colors = [
            UIColor(hex: "#FE592A").cgColor,
            UIColor(hex: "#FD3C12").cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint   = CGPoint(x: 1, y: 0.5)
        layer.insertSublayer(gradientLayer, at: 0)
        
        layer.cornerRadius = 8
        layer.masksToBounds = true
        titleLabel?.font = .boldSystemFont(ofSize: 16)
        updateStyle()
    }
    
    private func updateStyle() {
        if isEnabled {
            gradientLayer.isHidden = false
            backgroundColor = .clear
            setTitleColor(.white, for: .normal)
        } else {
            gradientLayer.isHidden = true
            backgroundColor = UIColor.black.withAlphaComponent(0.06)
            setTitleColor(UIColor.white.withAlphaComponent(0.38), for: .normal)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = layer.cornerRadius
    }
}
