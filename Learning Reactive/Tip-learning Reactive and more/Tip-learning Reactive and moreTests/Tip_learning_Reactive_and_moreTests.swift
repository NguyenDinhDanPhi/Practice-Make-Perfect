//
//  Tip_learning_Reactive_and_moreTests.swift
//  Tip-learning Reactive and moreTests
//
//  Created by dan phi on 13/02/2025.
//

import XCTest
import Combine
@testable import Tip_learning_Reactive_and_more

final class Tip_learning_Reactive_and_moreTests: XCTestCase {
    
    private var sut: CalculatorTipViewModel!
    private var cancelable: Set<AnyCancellable>!
    private var logoTapPublisher = PassthroughSubject<Void, Never>()
    override func setUp() {
        super.setUp()
        sut = .init()
        cancelable = .init()
    }
    override class func tearDown() {
        super.tearDown()
       
    }
    
    func testResultWithoutTipfor1Person() {
        // given
        let bill: Double = 100.0
        let tip: Tip = .none
        let split: Int = 1
        // when
        let input = buildInput(bill: bill, tip: tip, split: split)
        let output = sut.transform(input: input)
        // then
        output.upDateViewPublisher.sink { rs in
            XCTAssertEqual(rs.totalBill, 100.0)
            XCTAssertEqual(rs.totaltTip, 0)
            XCTAssertEqual(rs.amountPerPerson, 100.0)
            
        }.store(in: &cancelable)
        
    }
    
    func buildInput(bill: Double, tip: Tip, split: Int) -> CalculatorTipViewModel.InPut {
        return .init(billPublisher: Just(bill).eraseToAnyPublisher(),
                     tipPublisher: Just(tip).eraseToAnyPublisher(),
                     splitPublisher: Just(split).eraseToAnyPublisher(),
                     logoViewTapPublisher: logoTapPublisher.eraseToAnyPublisher())
    }
}
