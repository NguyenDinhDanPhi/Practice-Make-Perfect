//
//  ViewController.swift
//  Tip-learning Reactive and more
//
//  Created by dan phi on 13/02/2025.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa

class CalculatorViewController: UIViewController {
    
    let logoView = LogoView()
    let resultView = ResultView()
    let billInputView = BillInputView()
    let tipInputView = TipInputView()
    let spitInputView = SplitInputView()
    let viewModel = CalculatorTipViewModel()
    var cancelable = Set<AnyCancellable>()
    
    private lazy var viewTapPublisher: AnyPublisher<Void, Never> = {
        let tap = UITapGestureRecognizer(target: self, action: nil)
        view.addGestureRecognizer(tap)
        return tap.tapPublisher.flatMap { _ in
            Just(())
        }.eraseToAnyPublisher()
    }()
    
    private lazy var logoViewTapPublisher: AnyPublisher<Void, Never> = {
        let tap = UITapGestureRecognizer(target: self, action: nil)
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
        return tap.tapPublisher.flatMap { _ in
            Just(())
        }.eraseToAnyPublisher()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout() 
        binding()
        observe()
    }
    
    func binding() {
        
        let input = CalculatorTipViewModel.InPut(billPublisher: billInputView.valueBillPublisher,
                                                 tipPublisher: tipInputView.valueTipPublisher,
                                                 splitPublisher: spitInputView.valueSplitPublisher, 
                                                 logoViewTapPublisher: logoViewTapPublisher)
        let output = viewModel.transform(input: input)
        output.upDateViewPublisher.sink { [unowned self] rs in
            resultView.configure(rs: rs)
            
        }.store(in: &cancelable)
        
        output.resultCalculatorPublisher.sink { _ in
            print("hehe")
        }.store(in: &cancelable)
        
       
    }
    
    func observe() {
            viewTapPublisher.sink { [unowned self] _ in
                view.endEditing(true)
            }.store(in: &cancelable)
    }

    private func layout() {
        view.backgroundColor = ThemeColor.bg
        view.addSubview(logoView)
        view.addSubview(resultView)
        view.addSubview(billInputView)
        view.addSubview(tipInputView)
        view.addSubview(spitInputView)
        logoView.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.top.equalTo(view.snp.topMargin).offset(36)
            make.leading.equalTo(view.snp.leadingMargin).offset(16)
            make.trailing.equalTo(view.snp.trailingMargin).offset(-16)
        }
        resultView.snp.makeConstraints { make in
            make.height.equalTo(234)
            make.top.equalTo(logoView.snp.bottomMargin).offset(46)
            make.leading.equalTo(view.snp.leadingMargin).offset(16)
            make.trailing.equalTo(view.snp.trailingMargin).offset(-16)
        }
        billInputView.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.top.equalTo(resultView.snp.bottomMargin).offset(46)
            make.leading.equalTo(view.snp.leadingMargin).offset(16)
            make.trailing.equalTo(view.snp.trailingMargin).offset(-16)
        }
        tipInputView.snp.makeConstraints { make in
            make.height.equalTo(56+56+15)
            make.top.equalTo(billInputView.snp.bottomMargin).offset(46)
            make.leading.equalTo(view.snp.leadingMargin).offset(16)
            make.trailing.equalTo(view.snp.trailingMargin).offset(-16)
        }
        spitInputView.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.top.equalTo(tipInputView.snp.bottomMargin).offset(46)
            make.leading.equalTo(view.snp.leadingMargin).offset(16)
            make.trailing.equalTo(view.snp.trailingMargin).offset(-16)
        }

    }
}

