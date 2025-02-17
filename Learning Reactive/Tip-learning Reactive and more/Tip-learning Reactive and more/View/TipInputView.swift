//
//  TipInputView.swift
//  Tip-learning Reactive and more
//
//  Created by dan phi on 13/02/2025.
//

import UIKit
import Combine
import CombineCocoa

class TipInputView: UIView {
    
    private var tipSubject = CurrentValueSubject<Tip, Never>(.none)
    var valueTipPublisher: AnyPublisher<Tip, Never> {
        return tipSubject.eraseToAnyPublisher()
    }
    var cancelable = Set<AnyCancellable>()

    private lazy var headerView: HeaderView = {
        let view = HeaderView()
        view.config(top: "Choose", bot: "Your Tip")
        return view
    }()
    
    private lazy var tenButton: UIButton = {
        let button = buildTipButton(tip: .tenPercent)
        button.tapPublisher.flatMap {
            Just(Tip.tenPercent)
        }.assign(to: \.value, on: tipSubject)
            .store(in: &cancelable)
        
        return button
    }()
    
    private lazy var fifteenButton: UIButton = {
        let button = buildTipButton(tip: .fiftenPercent)
        button.tapPublisher.flatMap {
            Just(Tip.fiftenPercent)
        }.assign(to: \.value, on: tipSubject)
            .store(in: &cancelable)
        return button
    }()
    
    private lazy var twentyButton: UIButton = {
        let button = buildTipButton(tip: .twentyPercent)
        button.tapPublisher.flatMap {
            Just(Tip.twentyPercent)
        }.assign(to: \.value, on: tipSubject)
            .store(in: &cancelable)
        return button
    }()
    
    private lazy var stackButton: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [tenButton, fifteenButton, twentyButton])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
    }()
    
    private lazy var customTipButton: UIButton = {
        let button = UIButton()
        button.setTitle("Custom Tip", for: .normal)
        button.titleLabel?.font = ThemeFont.demiBold(ofSize: 20)
        button.backgroundColor = ThemeColor.primary
        button.tintColor = .white
        button.addCornerRadius(radius: 8.0)
        button.tapPublisher.sink { [weak self] _ in
            self?.handleCustomTipButton()
        }.store(in: &cancelable)
        return button
    }()
    
    lazy var buttonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [stackButton, customTipButton])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 16
        return stack
    }()
    
    init() {
        super.init(frame: .zero)
        layout()
        observe()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [headerView, buttonStack].forEach(addSubview(_:))
        
        buttonStack.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
        }
        
        headerView.snp.makeConstraints { make in
            make.trailing.equalTo(buttonStack.snp.leading).offset(-24)
            make.leading.equalToSuperview()
            make.width.equalTo(68)
            make.centerY.equalTo(buttonStack.snp.centerY)
        }
    }
    func handleCustomTipButton() {
        let alertController: UIAlertController = {
            let controller = UIAlertController(title: "Enter Tip you want!", message: nil, preferredStyle: .alert)
            controller.addTextField { text in
                text.placeholder = "Make it generous!"
                text.keyboardType = .numberPad
                text.autocorrectionType = .no
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                guard let text = controller.textFields?.first?.text, let value = Int(text) else { return }
                self?.tipSubject.send(.custom(value: value))
            }
            [cancelAction, okAction].forEach(controller.addAction(_:))
            return controller
        }()
        parentViewController?.present(alertController,animated: true)
    }
    private func buildTipButton(tip: Tip) -> UIButton {
        let button = UIButton(type: .custom)
        button.backgroundColor = ThemeColor.primary
        button.tintColor = .white
        button.addCornerRadius(radius: 8.0)
        let text = NSMutableAttributedString(string: tip.stringValue, attributes: [.font: ThemeFont.bold(ofSize: 20),
                                                                                   .foregroundColor: UIColor.white])
        text.addAttributes([.font: ThemeFont.bold(ofSize: 14)], range: NSMakeRange(2,1))
        button.setAttributedTitle(text, for: .normal)
        return button
    }
    
    func resetView() {
        [tenButton, fifteenButton, twentyButton, customTipButton].forEach {
            $0.backgroundColor = ThemeColor.primary
        }
        let text = NSMutableAttributedString(string: "Custom Tip",
                                             attributes: [.font: ThemeFont.bold(ofSize: 20)])
        customTipButton.setAttributedTitle(text, for: .normal)
    }
    
    func reset() {
        tipSubject.send(.none)
    }
    
    func observe() {
        tipSubject.sink { [unowned self] tip in
            resetView()
            switch tip {
            case .none:
                break
            case .tenPercent:
                tenButton.backgroundColor = ThemeColor.secondary
            case .fiftenPercent:
                fifteenButton.backgroundColor = ThemeColor.secondary
            case .twentyPercent:
                twentyButton.backgroundColor = ThemeColor.secondary
            case .custom(let value):
                customTipButton.backgroundColor = ThemeColor.secondary
                let text = NSMutableAttributedString(string: "\(value)",
                                                     attributes: [.font: ThemeFont.bold(ofSize: 20)])
                customTipButton.setAttributedTitle(text, for: .normal)
            }
        }.store(in: &cancelable)
    }
}

