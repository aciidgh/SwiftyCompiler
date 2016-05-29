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
    
    /// Current token.
    private(set) var token: Lexer.Token? = nil

    mutating func next() {
        token = lexer.next()
        while case Lexer.Token.whitespace? = token {
            token = lexer.next()
        }
    }

    mutating func parse() throws {
        next()
        loop: while true {
            switch token {
            case .eof?:
                print("End of input")
                break loop
            default:
                try handleTopLevelExpr()
            }
            next()
        }
    }

    mutating func handleTopLevelExpr() throws {
        let expr = try parseExpr()
        let topLevelFunction = FunctionAST(name: "__anon_expr", args: [], body: expr)
        print(topLevelFunction)
    }

    mutating func parseExpr() throws -> Expr {
        let lhs = try parsePrimary()
        return try parseBinaryOpRHS(precedence: 0, lhs: lhs)
    }

    mutating func parseBinaryOpRHS(precedence: Int, lhs: Expr) throws -> Expr {
        guard case Lexer.Token.op(let oper)? = token else { throw ParsingError.error("Expected binary operator \(token)") }
        next()
        let rhs = try parsePrimary()
        let binaryOpExpr = BinaryOpExpr(op: oper, lhs: lhs, rhs: rhs)
        return binaryOpExpr
    }

    mutating func parsePrimary() throws -> Expr {
        switch token {
        case .number(let val)?:
            let numberExpr = NumberExpr(val: val)
            next()
            return numberExpr
        case .identifier(let name)?:
           return try parseIdentifierExpr(name: name) 
        default:
            throw ParsingError.error("Unknown token: \(token) at \(lexer.index) when expecting expression.")
        }
    }

    mutating func parseIdentifierExpr(name: String) throws -> Expr {
        next()
        guard case .parathensisBegin? = token else {
            return VariableExpr(name: name)
        }
        next() 
        var args = [Expr]()
        if case .parathensisEnd? = self.token {
        } else {
            while true {
                let arg = try parseExpr()
                args.append(arg)

                if case .parathensisEnd? = token {
                    break
                }

                guard case .comma? = token else {
                    throw ParsingError.error("Expected comma in argument list")
                }
                next()
            }
        }
        return CallExpr(callee: name, args: args)
    }
}
