//
//  ResultView.swift
//  Tip-learning Reactive and more
//
//  Created by dan phi on 13/02/2025.
//

import UIKit
class ResultView: UIView {
    lazy var headerLabel: UILabel = {
        LabelFactory.build(text: "Total p/Person", font: ThemeFont.demiBold(ofSize: 18))
    }()
    
    private lazy var amountPerPerson: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        let text = NSMutableAttributedString(string: "$0", attributes: [.font: ThemeFont.bold(ofSize: 48)])
        text.addAttributes([.font: ThemeFont.bold(ofSize: 24)], range: NSMakeRange(0, 1))
        label.attributedText = text
        return label
    }()
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeColor.separator
        return view
    }()
    
    private lazy var vStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [headerLabel, amountPerPerson, lineView, hStack])
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var hStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [AmountView(), UIView(), AmountView()])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(vStack)
        vStack.snp.makeConstraints { make in
            make.top.equalTo(snp.topMargin).offset(24)
            make.leading.equalTo(snp.leadingMargin).offset(24)
            make.bottom.equalTo(snp.bottomMargin).offset(-24)
            make.trailing.equalTo(snp.trailingMargin).offset(-24)
        }
      
        lineView.snp.makeConstraints { make in
            make.height.equalTo(2)
        }
        addShaDow(offset: CGSize(width: 0, height: 3), color: .black, radius: 12.0, opacity: 0.1)
        
    }
}

class AmountView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
        backgroundColor = .red
        
    }
}
