import XCTest
@testable import TATLib

final class TATLibTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(TATLib().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
