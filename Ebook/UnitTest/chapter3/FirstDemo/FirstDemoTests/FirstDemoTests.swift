//  Created by Dominik Hauser on 13.08.21.
//  
//

import XCTest
@testable import FirstDemo

class FirstDemoTests: XCTestCase {
    
    var blogger: Blogger!

  override func setUpWithError() throws {
      blogger = Blogger()

    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
      blogger = nil
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func test_numberOfVowels_whenGivenDominik_shouldReturn3() {
    let viewController = ViewController()

    let result = viewController.numberOfVowels(in: "Dominik")

    XCTAssertEqual(result, 3,
                   "Expected 3 vowels in 'Dominik' but got \(result)")
  }

  func test_comparingDictionariesWithCustomAssertFunction() {
    let dict1 = ["id": "2", "name": "foo"]
    let dict2 = ["id": "2", "name": "fo"]

    DDHAssertEqual(dict1, dict2)
  }
    func test_makeHeadline_shouldCapitalisePassedInString() {
        let input = "the accessibility inspector"
        	
        let result = blogger.makeHeadline(from: "the Accessibility inspector")
        let expected = "The Accessibility Inspector"
        XCTAssertEqual(result, expected)
    }
    
    func test_makeHeadline_shouldCapitalisePassedInString_2() {
        let input = "The contextual action menu"
        let result = blogger.makeHeadline(from: input)
        let expected = "The Contextual Action Menu"
        XCTAssertEqual(result, expected)
    }
}

func DDHAssertEqual<A: Equatable, B: Equatable>(
  _ first: [A:B],
  _ second: [A:B],
  file: StaticString = #filePath,
  line: UInt = #line) {

    if first == second {
      return
    }

    for key in first.keys {

      if first[key] != second[key] {
        let value1 = String(describing: first[key]!)
        let value2 = String(describing: second[key]!)
        let keyValue1 = "\"\(key)\": \(value1)"
        let keyValue2 = "\"\(key)\": \(value2)"
        let message = "\(keyValue1) is not equal to \(keyValue2)"
        XCTFail(message, file: file, line: line)
        return
      }
    }
  }
