enum ParsingError: ErrorProtocol {
    case error(String)
}

struct Parser {
    private var lexer: Lexer
    
    var data: String {
        return lexer.data
    }

    init(_ data: String) {
        lexer = Lexer(data)
    }

    

    mutating func parse() throws {
        
    }
}
