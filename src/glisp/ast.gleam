////// Represents an expression in a Lisp-like language.
////// Converts an expression to its string representation.

import gleam/int
import gleam/list
import gleam/string

///
/// The expression can be one of:
/// - `Atom`: A symbolic name or identifier (e.g., `+`, `define`, variable names)
/// - `Number`: An integer value
/// - `List`: A list of expressions, typically representing function calls or special forms
/// - `Builtin`: A built-in function that can evaluate lists of expressions
pub type Expr {
  Atom(String)
  Number(Int)
  List(List(Expr))
  Builtin(fn(List(Expr)) -> Result(Expr, String))
}

///
/// This function returns a human-readable string that represents the given expression:
/// - Atoms are converted to their name
/// - Numbers are converted to their string representation
/// - Lists are converted recursively with elements joined by spaces and enclosed in parentheses
/// - Builtin functions are represented as "#<builtin function>"
pub fn expr_to_string(expr: Expr) -> String {
  case expr {
    Atom(name) -> name
    Number(n) -> int.to_string(n)
    List(elements) -> {
      let elements_str =
        list.map(elements, expr_to_string)
        |> string.join(" ")
      "(" <> elements_str <> ")"
    }
    Builtin(_) -> "#<builtin function>"
  }
}
