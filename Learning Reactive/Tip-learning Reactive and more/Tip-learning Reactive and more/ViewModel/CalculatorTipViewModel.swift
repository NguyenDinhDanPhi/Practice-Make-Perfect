//
//  CalculatorTipViewModel.swift
//  Tip-learning Reactive and more
//
//  Created by dan phi on 16/02/2025.
//

import UIKit
import Combine
import CombineCocoa
class CalculatorTipViewModel {
    struct InPut {
        let billPublisher: AnyPublisher<Double, Never>
        let tipPublisher:  AnyPublisher<Tip, Never>
        let splitPublisher: AnyPublisher<Int, Never>
        let logoViewTapPublisher: AnyPublisher<Void, Never>
    }
    
    struct OutPut {
        let upDateViewPublisher: AnyPublisher<Results, Never>
        let resultCalculatorPublisher: AnyPublisher<Void, Never>
    }
    
    var cancelable = Set<AnyCancellable>()
    private let audioPlayerService: AudioPlayService
    init(audioPlayerService: AudioPlayService = DefaultAudioPlayer()) {
        self.audioPlayerService = audioPlayerService
    }
    
    func transform(input: InPut) -> OutPut {
        let updateViewPublisher = Publishers.CombineLatest3(
            input.billPublisher,
            input.tipPublisher,
            input.splitPublisher)
            .flatMap { [unowned self] (bill, tip, split) in
                let total = getTipAmount(bill: bill, tip: tip)
                let totalBill = bill + total
                let amountPerson = totalBill / Double(split)
                let result = Results(amountPerPerson: amountPerson, totalBill: totalBill, totaltTip: total)
                return Just(result)
            }.eraseToAnyPublisher()

        
        let rs = Results(amountPerPerson: 500, totalBill: 1000, totaltTip: 50.0)
        let resultCalculatorPublisher = input.logoViewTapPublisher.handleEvents(receiveOutput: { [unowned self]  _  in
            audioPlayerService.playSound()
        }).flatMap {
            return Just($0)
        }.eraseToAnyPublisher()
        return OutPut(upDateViewPublisher: updateViewPublisher, resultCalculatorPublisher: resultCalculatorPublisher)
    }
    
    func getTipAmount(bill: Double, tip: Tip) -> Double {
        switch tip {
        case .none:
            return 0
        case .tenPercent:
            return bill * 0.1
        case .fiftenPercent:
            return bill * 0.15
        case .twentyPercent:
            return bill * 0.2
        case .custom(let value):
            return Double(value)
        }
    }
}
