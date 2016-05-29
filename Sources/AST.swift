
/// Base class for all expressions.
class Expr {
}

/// Numeric literals like 1, 2, 5665.
final class NumberExpr: Expr {
    let value: Int
    init(val: Int) {
        value = val
    }
}

/// Expression class for referencing variables like `foo`.
final class VariableExpr: Expr {
    let name: String
    init(name: String) {
        self.name = name
    }
}

/// Binary operation like 1 + 2.
final class BinaryOpExpr: Expr {
    let lhs: Expr
    let rhs: Expr
    let op: Lexer.Token.Operator
    init(op: Lexer.Token.Operator, lhs: Expr, rhs: Expr) {
        self.op = op
        self.lhs = lhs
        self.rhs = rhs
    }
}
