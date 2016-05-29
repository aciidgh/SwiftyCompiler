import XCTest
@testable import SwiftyCompiler

final class LexerTests: XCTestCase {

    func testLexFunction() {
        let data = "func hello(a, b) { }"
        var lexer = Lexer(data)
        let tokens = lexer.allTokens().map { "\($0)" }
        XCTAssertEqual(tokens, ["func", "whitespace", "hello", "(", "a", ",", "whitespace", "b", ")", "whitespace", "{", "whitespace", "}"])
    }

    func testLexNumber() {
        let data = "func 12345"
        var lexer = Lexer(data)
        let tokens = lexer.allTokens().map { "\($0)" }
        XCTAssertEqual(tokens, ["func", "whitespace", "12345"])
    }
}
