import XCTest
@testable import SwiftyCompiler

final class ParserTests: XCTestCase {

    func testLexFunction() {
        let data = "4 + 5"
        var parser = Parser(data)
        do {
            try parser.parse()
        } catch {
            print("error: \(error)")
        }
    }
}
