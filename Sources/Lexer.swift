//import CLLVM
import Darwin.C

struct Lexer {
    enum Token {
        case number(Int)
        case identifier(String)
        case function
        case eof
        case whitespace
        case comma
        case curlybracesBegin 
        case curlybracesEnd
        case parathensisBegin
        case parathensisEnd
        case unknown(UInt8)
    }

    // Data to be Lexed.
    let data: String

    // Current Index.
    private(set) var index: String.UTF8View.Index

    init(_ data: String) {
        self.data = data
        self.index = self.data.utf8.startIndex
    }

    private func peek() -> UInt8? {
        // Reached end, return.
        guard index != data.utf8.endIndex else { return nil }
        // Get the char.
        return data.utf8[index]
    }

    // Eat and return the next char.
    private mutating func eat() -> UInt8? {
        guard index != data.utf8.endIndex else { return nil }
        let char = data.utf8[index]
        // Increment the index.
        index = data.utf8.index(after: index)
        return char
    }

    mutating func next() -> Token {
        let startIndex = index
        // Eat the next character otherwise we reached EOF.
        guard let char = eat() else { return .eof } 

        switch char {
        case let c where c.isSpace:
            while let next = peek() where next.isSpace {
                let _ = eat()
            }
            return .whitespace

        case UInt8(ascii: "{"):
            return .curlybracesBegin

        case UInt8(ascii: "}"):
            return .curlybracesEnd

        case UInt8(ascii: "("):
            return .parathensisBegin

        case UInt8(ascii: ")"):
            return .parathensisEnd

        case UInt8(ascii: ","):
            return .comma

        case let c where c.isAlphaNum:
            while let next = peek() where next.isAlphaNum {
                let _ = eat()
            }
            return .identifier(String(data.utf8[startIndex..<index]))
        default:
            // Unknown character found. 
        return .unknown(char) 
        }
    }

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

