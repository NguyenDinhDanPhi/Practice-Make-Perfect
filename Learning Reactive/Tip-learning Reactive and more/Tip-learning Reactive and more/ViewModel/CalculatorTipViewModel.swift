//
//  CalculatorTipViewModel.swift
//  Tip-learning Reactive and more
//
//  Created by dan phi on 16/02/2025.
//

import UIKit
import Combine

class CalculatorTipViewModel {
    struct InPut {
        let billPublisher: AnyPublisher<Double, Never>
        let tipPublisher:  AnyPublisher<Tip, Never>
        let splitPublisher: AnyPublisher<Int, Never>
    }
    
    struct OutPut {
        let upDateViewPublisher: AnyPublisher<Results, Never>
    }
    var cancelable = Set<AnyCancellable>()

    func transform(input: InPut) -> OutPut {
        input.billPublisher.sink { bill in
            print("the bill \(bill)")
        }.store(in: &cancelable)
        
        let rs = Results(amountPerPerson: 500, totalBill: 1000, totaltTip: 50.0)
        return OutPut(upDateViewPublisher: Just(rs).eraseToAnyPublisher())
    }
}
