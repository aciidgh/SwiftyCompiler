
struct Lexer {
    enum Token {
        // An integer number.
        case number(Int)
        // An identifier.
        case identifier(String)
        // A function declaration `func`.
        case function
        // EOF.
        case eof
        // Any amount of whitespace.
        case whitespace
        // ,
        case comma
        // {
        case curlybracesBegin 
        // }
        case curlybracesEnd
        // (
        case parathensisBegin
        // )
        case parathensisEnd
        // Variable declaration `var`.
        case variableDecl
        // Operator like assignment, add, subtract, multiply etc.
        case op(Operator)
        // Unknown character.
        case unknown(UInt8)

        enum Operator {
            // Addition operator.
            case add
            // Assignment operator.
            case assignment
        }
    }

    // Data to be lexed.
    let data: String

    // Current index.
    private(set) var index: String.UTF8View.Index

    init(_ data: String) {
        self.data = data
        self.index = self.data.utf8.startIndex
    }
    
    // Look at current character but don't eat it.
    private func peek() -> UInt8? {
        // Reached end, return.
        guard index != data.utf8.endIndex else { return nil }
        // Get the char.
        return data.utf8[index]
    }

    // Eat and increment the current index.
    private mutating func eat() -> UInt8? {
        // Don't go beyond the last index.
        guard index != data.utf8.endIndex else { return nil }
        // Get the current character.
        let char = data.utf8[index]
        // Increment the index.
        index = data.utf8.index(after: index)
        return char
    }

    mutating func next() -> Token {
        // Store the start index to be able to form ranges.
        let startIndex = index
        // Eat the next character otherwise we reached EOF.
        guard let char = eat() else { return .eof } 

        switch char {
        case let c where c.isSpace:
            // Consume rest of the whitespace if present.
            while let next = peek() where next.isSpace {
                let _ = eat()
            }
            return .whitespace

        case let c where c.isNumber:
            // Get the entire number.
            while let next = peek() where next.isNumber {
                let _ = eat()
            }
            let str = String(data.utf8[startIndex..<index])!
            guard let num = Int(str) else { fatalError("Expected integer number \(str)") }
            return .number(num)

        case let c where c.isAlphaNum:
            // Get the entire identifier.
            while let next = peek() where next.isAlphaNum {
                let _ = eat()
            }
            let str = String(data.utf8[startIndex..<index])!
            return Token(str: str)

        default:
            // Single char tokens.
            return Token(char: char)
        }
    }

    // Lex and return list of all the tokens.
    mutating func allTokens() -> [Token] {
        var tokens = [Token]()
        var token = next()
        while true {
            tokens += [token]
            token = next()
            if case Lexer.Token.eof = token { break }
        }
        return tokens
    }
}

extension Lexer.Token {
    // Keywords init.
    init(str: String) {
        switch str {
        case "func":
            self = .function
        case "var":
            self = .variableDecl
        default:
            self = .identifier(str)
        }
    }

    // Operators etc.
    init(char: UInt8) {
        switch char {
        case UInt8(ascii: "{"):
            self = .curlybracesBegin

        case UInt8(ascii: "}"):
            self = .curlybracesEnd

        case UInt8(ascii: "("):
            self = .parathensisBegin

        case UInt8(ascii: ")"):
            self = .parathensisEnd

        case UInt8(ascii: ","):
            self = .comma

        case UInt8(ascii: "="):
            self = .op(.assignment)

        case UInt8(ascii: "+"):
            self = .op(.add)

//        case UInt8(ascii: "-"):
//        case UInt8(ascii: "*"):
//        case UInt8(ascii: "/"):
//        case UInt8(ascii: ""):
        default:
            self = .unknown(char) 
        }
    }
}

extension Lexer.Token: CustomStringConvertible {
    var description: String {
        switch self {
        case number(let num):
            return "Int(\(num))"
        case identifier(let str):
            return str
        case function:
            return "function"
        case eof:
            return "EOF"
        case whitespace:
            return "whitespace"
        case comma:
            return ","
        case curlybracesBegin:
            return "{"
        case curlybracesEnd:
            return "}"
        case parathensisBegin:
            return "("
        case parathensisEnd:
            return ")"
        case variableDecl:
            return "variableDecl"
        case op(let op):
            return "\(op)"
        case unknown(let char):
            return string(char)
        }
    }
}

private extension UInt8 {
    var isSpace: Bool {
        return self == UInt8(ascii: " ")
    }

    var isAlphaNum: Bool {
        switch self {
            case UInt8(ascii: "a")...UInt8(ascii: "z"),
                 UInt8(ascii: "A")...UInt8(ascii: "Z"),
                 UInt8(ascii: "0")...UInt8(ascii: "9"),
                 UInt8(ascii: "_"),
                 UInt8(ascii: "-"):
            return true
        default:
            return false
        }
    }

    var isNumber: Bool {
        switch self {
            case UInt8(ascii: "0")...UInt8(ascii: "9"):
            return true
        default:
            return false
        }
    }
}

func string(_ arr: UInt8) -> String {
    let tmp = [arr, UInt8(0)]
    return tmp.withUnsafeBufferPointer { ptr in
        return String(cString: unsafeBitCast(ptr.baseAddress, to: UnsafePointer<CChar>.self))
    }
}
