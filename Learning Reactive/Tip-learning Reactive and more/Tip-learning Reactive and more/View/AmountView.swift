//
//  AmountView.swift
//  Tip-learning Reactive and more
//
//  Created by dan phi on 14/02/2025.
//

import UIKit
import SnapKit
class AmountView: UIView {
    
    private let title: String
    private let textAlignment:  NSTextAlignment
    private let amountLabelId: String
    lazy var headerLabel: UILabel = {
        LabelFactory.build(text: title, font: ThemeFont.regular(ofSize: 18), textColor: ThemeColor.text,textAlignment: textAlignment)
    }()
    
    private lazy var amountPerPerson: UILabel = {
        let label = UILabel()
        label.textAlignment = textAlignment
        let text = NSMutableAttributedString(string: "$0", attributes: [.font: ThemeFont.bold(ofSize: 24)])
        text.addAttributes([.font: ThemeFont.bold(ofSize: 16)], range: NSMakeRange(0, 1))
        label.textColor = ThemeColor.primary
        label.attributedText = text
        label.accessibilityIdentifier = amountLabelId
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [headerLabel, amountPerPerson])
        view.axis = .vertical
        return view
    }()
    init(title: String, textAlignment: NSTextAlignment, amountLabelId: String) {
        self.title = title
        self.textAlignment = textAlignment
        self.amountLabelId = amountLabelId
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(amount: Double) {
        let text = NSMutableAttributedString(string: amount.currencyFormatter, attributes: [.font: ThemeFont.bold(ofSize: 24)])
        text.addAttributes([.font: ThemeFont.bold(ofSize: 16)], range: NSMakeRange(0, 1))
        amountPerPerson.attributedText = text
    }
}
