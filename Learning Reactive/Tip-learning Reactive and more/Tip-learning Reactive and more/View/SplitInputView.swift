//
//  SplitInputView.swift
//  Tip-learning Reactive and more
//
//  Created by dan phi on 13/02/2025.
//

import UIKit
class SplitInputView: UIView {
    lazy var headerView: HeaderView = {
        let view = HeaderView()
        view.config(top: "Split", bot: "The Tolal")
        return view
    }()
    
    lazy var decrementButton: UIButton = {
        let button = buildButton(text: "--", corners: [.layerMinXMaxYCorner,.layerMinXMinYCorner])
        return button
    }()
    
    lazy var inrementButton: UIButton = {
        let button = buildButton(text: "+", corners: [.layerMaxXMinYCorner,.layerMaxXMaxYCorner])
        return button
    }()
    
    lazy var quantityLabel: UILabel = {
        let label = LabelFactory.build(text: "1", font: ThemeFont.bold(ofSize: 20))
        return label
    }()
    
    lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [decrementButton, quantityLabel, inrementButton])
        stack.axis = .horizontal
        stack.spacing = 0
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
        [headerView, stack].forEach(addSubview(_:))
        stack.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            
        }
        [inrementButton, decrementButton].forEach { button in
            button.snp.makeConstraints { make in
                make.width.equalTo(60)
            }
        }
        
        headerView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalTo(stack.snp.centerY)
            make.trailing.equalTo(stack.snp.leading).offset(-24)
            make.width.equalTo(68)
        }
    }
    
    func buildButton(text: String, corners: CACornerMask) -> UIButton {
        let button = UIButton()
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = ThemeFont.bold(ofSize: 20)
        button.addRoundedCorners(corner: corners, radius: 8.0)
        button.backgroundColor = ThemeColor.primary
        return button
    }
}
