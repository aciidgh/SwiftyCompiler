import XCTest
@testable import SwiftyCompiler

final class LexerTests: XCTestCase {

    func testLexFunction() {
        let data = "func hello(a, b)\n{ }"
        var lexer = Lexer(data)
        let tokens = lexer.allTokens().map { "\($0)" }
        XCTAssertEqual(tokens, ["function", "whitespace", "hello", "(", "a", ",", "whitespace", "b", ")", "newline", "{", "whitespace", "}"])
    }

    func testLexNumber() {
        let data = "var sup = 12 + 45"
        var lexer = Lexer(data)
        let tokens = lexer.allTokens().map { "\($0)" }
        XCTAssertEqual(tokens, ["variableDecl", "whitespace", "sup", "whitespace", "assignment", "whitespace", "Int(12)", "whitespace", "add", "whitespace", "Int(45)"])
    }
}
