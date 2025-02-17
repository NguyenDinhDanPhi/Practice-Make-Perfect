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
    var audio: MockAudioPlayerService!
    override func setUp() {
        super.setUp()
        audio = .init()
        sut = .init(audioPlayerService: audio)
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
    
    func testResultWithoutTipfor2Person() {
        // given
        let bill: Double = 100.0
        let tip: Tip = .none
        let split: Int = 2
        // when
        let input = buildInput(bill: bill, tip: tip, split: split)
        let output = sut.transform(input: input)
        // then
        output.upDateViewPublisher.sink { rs in
            XCTAssertEqual(rs.totalBill, 100.0)
            XCTAssertEqual(rs.totaltTip, 0)
            XCTAssertEqual(rs.amountPerPerson, 50.0)
            
        }.store(in: &cancelable)
        
    }
    
    func testResultWith10PercenTipfor2Person() {
        // given
        let bill: Double = 100.0
        let tip: Tip = .tenPercent
        let split: Int = 2
        // when
        let input = buildInput(bill: bill, tip: tip, split: split)
        let output = sut.transform(input: input)
        // then
        output.upDateViewPublisher.sink { rs in
            XCTAssertEqual(rs.totalBill, 110.0)
            XCTAssertEqual(rs.totaltTip, 10.0)
            XCTAssertEqual(rs.amountPerPerson, 55.0)
            
        }.store(in: &cancelable)
        
    }
    
    func testResultWithCustomTipTipfor2Person() {
        // given
        let bill: Double = 100.0
        let tip: Tip = .custom(value: 100)
        let split: Int = 2
        // when
        let input = buildInput(bill: bill, tip: tip, split: split)
        let output = sut.transform(input: input)
        // then
        output.upDateViewPublisher.sink { rs in
            XCTAssertEqual(rs.totalBill, 200.0)
            XCTAssertEqual(rs.totaltTip, 100.0)
            XCTAssertEqual(rs.amountPerPerson, 100.0)
            
        }.store(in: &cancelable)
        
    }
    
    func testSoundWhenTapLogoView() {
        // given
        let ip = buildInput(bill: 100, tip: .fiftenPercent, split: 1)
        let out = sut.transform(input: ip)
        let ex1 = XCTestExpectation(description: "reset called")
        let ex2 = audio.ex
        // then
        out.resetCalculatorPublisher.sink { _ in
            ex1.fulfill()
        }.store(in: &cancelable)
        
        // when
        logoTapPublisher.send()
        wait(for: [ex1,ex2], timeout: 1.0)
        
    }

    
    func buildInput(bill: Double, tip: Tip, split: Int) -> CalculatorTipViewModel.InPut {
        return .init(billPublisher: Just(bill).eraseToAnyPublisher(),
                     tipPublisher: Just(tip).eraseToAnyPublisher(),
                     splitPublisher: Just(split).eraseToAnyPublisher(),
                     logoViewTapPublisher: logoTapPublisher.eraseToAnyPublisher())
    }
}

class MockAudioPlayerService: AudioPlayService {
    var ex = XCTestExpectation(description: "sound played")
    func playSound() {
        ex.fulfill()
    }
    
    
}
