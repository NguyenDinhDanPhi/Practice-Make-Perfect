//
//  Tip_learning_Reactive_and_moreSnapShotTest.swift
//  Tip-learning Reactive and moreTests
//
//  Created by dan phi on 18/02/2025.
//

import XCTest
import SnapshotTesting
@testable import Tip_learning_Reactive_and_more

final class Tip_learning_Reactive_and_moreSnapShotTest: XCTestCase {
    var screenWidth: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    func testLogoView() {
        // given
        let size = CGSize(width: screenWidth, height: 48)
        // when
        let view = LogoView()
        // then
        assertSnapshot(of: view, as: .image(size: size))
    }
    
    func testResultView() {
        // given
        let size = CGSize(width: screenWidth, height: 234)
        // when
        let view = ResultView()
        // then
        assertSnapshot(of: view, as: .image(size: size))
    }
    
    func testBillInputView() {
        // given
        let size = CGSize(width: screenWidth, height: 56)
        // when
        let view = BillInputView()
        // then
        assertSnapshot(of: view, as: .image(size: size))
    }
    
    
    func testTipInputView() {
        // given
        let size = CGSize(width: screenWidth, height: 56+56+15)
        // when
        let view = TipInputView()
        // then
        assertSnapshot(of: view, as: .image(size: size))
    }
    
    func testSplitInputViewtView() {
        // given
        let size = CGSize(width: screenWidth, height: 56)
        // when
        let view = SplitInputView()
        // then
        assertSnapshot(of: view, as: .image(size: size))
    }
    
}
