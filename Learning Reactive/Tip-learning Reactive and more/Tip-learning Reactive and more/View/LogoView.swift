//
//  LogoView.swift
//  Tip-learning Reactive and more
//
//  Created by dan phi on 13/02/2025.
//

import UIKit

class LogoView: UIView {
    private lazy var imageView: UIImageView = {
        let view = UIImageView(image: .init(named: "icCalculatorBW"))
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var topLabel: UILabel = {
        let label = UILabel()
        let text = NSMutableAttributedString(string: "Mr TIP", attributes: [.font: ThemeFont.bold(ofSize: 16)])
        text.addAttributes([.font: ThemeFont.bold(ofSize: 24)], range: NSMakeRange(3, 3))
        label.attributedText = text
        return label
    }()
    
    private lazy var botLabel: UILabel = {
        LabelFactory.build(text: "Calculator",
                           font: ThemeFont.demiBold(ofSize: 20),
                           textAlignment: .left)
    }()
    
    private lazy var vStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [topLabel, botLabel])
        stack.axis = .vertical
        stack.spacing = -4
        return stack
    }()
    
    private lazy var hStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [imageView, vStack])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        return stack
    }()
    
    init() {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(hStack)
        hStack.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        imageView.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.width.equalTo(48)
        }
    }
}
