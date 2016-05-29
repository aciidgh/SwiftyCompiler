
/// Base class for all expressions.
class Expr {
}

/// Numeric literals like 1, 2, 5665.
final class NumberExpr: Expr, CustomStringConvertible {
    let value: Int
    init(val: Int) {
        value = val
    }

    var description: String {
        return "\(value)"
    }
}

/// Expression class for referencing variables like `foo`.
final class VariableExpr: Expr, CustomStringConvertible {
    let name: String
    init(name: String) {
        self.name = name
    }

    var description: String {
        return "\(name)"
    }
}

/// Binary operation like 1 + 2.
final class BinaryOpExpr: Expr, CustomStringConvertible {
    let lhs: Expr
    let rhs: Expr
    let op: Lexer.Token.Operator
    init(op: Lexer.Token.Operator, lhs: Expr, rhs: Expr) {
        self.op = op
        self.lhs = lhs
        self.rhs = rhs
    }
    var description: String {
        return "\(lhs) \(op) \(rhs)"
    }
}

/// Expression for function calls.
final class CallExpr: Expr, CustomStringConvertible {
    let callee: String
    let args: [Expr]
    init(callee: String, args: [Expr]) {
        self.callee = callee
        self.args = args
    }
    var description: String {
        return "\(callee) \(args)"
    }
}

/// Represents function defination.
final class FunctionAST: CustomStringConvertible{
    let name: String
    let args: [String]
    let body: Expr
    init(name: String, args: [String], body: Expr) {
        self.name = name
        self.args = args
        self.body = body
    }
    var description: String {
        return "Function \(name) \(args) \(body)"
    }
}
