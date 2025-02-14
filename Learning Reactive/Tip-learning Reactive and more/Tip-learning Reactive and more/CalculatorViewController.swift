//
//  ViewController.swift
//  Tip-learning Reactive and more
//
//  Created by dan phi on 13/02/2025.
//

import UIKit
import SnapKit
class CalculatorViewController: UIViewController {
    
    let logoView = LogoView()
    let resultView = ResultView()
    let billInputView = BillInputView()
    let tipInputView = TipInputView()
    let spitInputView = SplitInputView()
    
    private lazy var  stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [logoView, resultView, billInputView, tipInputView, spitInputView])
        stackView.axis = .vertical
        stackView.spacing = 36
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        layout() 
        let screenSize = UIScreen.main.bounds
        print("Chiều rộng: \(screenSize.width), Chiều cao: \(screenSize.height)")

        // Do any additional setup after loading the view.
    }

    private func layout() {
        view.backgroundColor = ThemeColor.bg
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leadingMargin).offset(16)
            make.trailing.equalTo(view.snp.trailingMargin).offset(-16)
            make.bottom.equalTo(view.snp.bottomMargin).offset(-16)
            make.top.equalTo(view.snp.topMargin).offset(16)
        }
        logoView.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        resultView.snp.makeConstraints { make in
            make.height.equalTo(224)
        }
        billInputView.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        tipInputView.snp.makeConstraints { make in
            make.height.equalTo(56+56+15)
        }
        spitInputView.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
    }
}

