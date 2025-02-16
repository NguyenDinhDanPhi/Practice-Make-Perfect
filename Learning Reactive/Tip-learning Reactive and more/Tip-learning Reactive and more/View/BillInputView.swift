//
//  BillInputView.swift
//  Tip-learning Reactive and more
//
//  Created by dan phi on 13/02/2025.
//

import UIKit
import Combine
import CombineCocoa


class BillInputView: UIView {
    
    var cancelable = Set<AnyCancellable>()
    private var billSubject: PassthroughSubject<Double, Never> = .init()
    var billPublisher: AnyPublisher<Double, Never> {
        return billSubject.eraseToAnyPublisher()
    }
    private lazy var headerView: HeaderView = {
        let view = HeaderView()
        view.config(top: "Enter", bot: "Your bill")
        return view
    }()
    private lazy var textFieldContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addCornerRadius(radius: 8.0)
        return view
    }()
    
    private lazy var currencyDenominationLabel: UILabel = {
        let label = LabelFactory.build(text: "$", font: ThemeFont.bold(ofSize: 24))
      //  label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private lazy var textField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.font = ThemeFont.demiBold(ofSize: 28)
        tf.keyboardType = .decimalPad
        tf.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        tf.tintColor = ThemeColor.text
        tf.textColor = ThemeColor.text
        //toolbar
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 36))
        toolbar.barStyle = .default
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
        toolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), doneButton]
        toolbar.isUserInteractionEnabled = true
        tf.inputAccessoryView = toolbar
        return tf
    }()
    
    
    
    
    init() {
        super.init(frame: .zero)
        layout()
        observer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [headerView, textFieldContainerView].forEach(addSubview(_:))
        [currencyDenominationLabel, textField].forEach(textFieldContainerView.addSubview(_:))
        headerView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.bottom.top.equalToSuperview()
            make.centerY.equalTo(textFieldContainerView.snp.centerY)
            make.width.equalTo(68)
            make.trailing.equalTo(textFieldContainerView.snp.leading).offset(-17)
        }
        textFieldContainerView.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
        }
        
        currencyDenominationLabel.snp.makeConstraints { make in
            make.bottom.top.equalToSuperview()
            make.leading.equalTo(textFieldContainerView.snp.leading).offset(16)
            make.width.equalTo(20)
        }
        
        textField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(currencyDenominationLabel.snp.trailing).offset(16)
            make.trailing.equalTo(textFieldContainerView.snp.trailing).offset(-16)
        }
    }
    
    func observer() {
        textField.textPublisher.sink { [unowned self] text in
           billSubject.send(text?.doubleValue ?? 0)
        }.store(in: &cancelable)
    }
                                         
    @objc func doneTapped(){
        textField.endEditing(true )
    }
}

class HeaderView: UIView {
    
    lazy var topLabel: UILabel = {
        LabelFactory.build(text: nil, font: ThemeFont.bold(ofSize: 18))
    }()
    lazy var botLabel: UILabel = {
        LabelFactory.build(text: nil, font: ThemeFont.regular(ofSize: 16))
    }()
    let topView = UIView()
    let botView = UIView()
    
    private lazy var stackView: UIStackView  = {
        let stack = UIStackView(arrangedSubviews: [topView, topLabel, botLabel,botView])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = -4
        return stack
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        topView.snp.makeConstraints { make in
            make.height.equalTo(botView)
        }
        
    }
    
    func config(top: String, bot: String) {
        topLabel.text = top
        botLabel.text = bot
    }
}
