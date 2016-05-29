import XCTest
@testable import SwiftyCompiler

final class LexerTests: XCTestCase {

    func testLexFunction() {
        let data = "func hello(a, b) { }"
        var lexer = Lexer(data)
        let tokens = lexer.allTokens() 
        print(tokens)
    }
}
