import XCTest
@testable import SwiftyCompiler

final class LexerTests: XCTestCase {

    func testLexFunction() {
        let data = "func hello(a, b) { }"
        var lexer = Lexer(data)
        let tokens = lexer.allTokens().map { "\($0)" }
        XCTAssertEqual(tokens, ["function", "whitespace", "hello", "(", "a", ",", "whitespace", "b", ")", "whitespace", "{", "whitespace", "}"])
    }

    func testLexNumber() {
        let data = "var sup = 12 + 45"
        var lexer = Lexer(data)
        let tokens = lexer.allTokens().map { "\($0)" }
        XCTAssertEqual(tokens, ["variableDecl", "whitespace", "sup", "whitespace", "assignmentOp", "whitespace", "Int(12)", "whitespace", "addOp", "whitespace", "Int(45)"])
    }
}
