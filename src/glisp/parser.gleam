////// Parses a list of tokens into an abstract syntax tree expression.

import gleam/int
import gleam/list
import gleam/result
import glisp/ast.{type Expr, Atom, List, Number}

/// This function takes a list of string tokens and attempts to parse them
/// into a structured expression according to a simple Lisp-like syntax.
/// It can recognize atoms, numbers, and nested lists.
///
/// ## Examples
///
/// ```
/// parse(["(", "hello", "world", ")"])
/// // -> Ok(List([Atom("hello"), Atom("world")]))
///
/// parse(["42"])
/// // -> Ok(Number(42))
///
/// parse(["missing_paren", "("])
/// // -> Error("Unclosed list")
/// ```
pub fn parse(tokens: List(String)) -> Result(Expr, String) {
  case parse_tokens(tokens) {
    Ok(#(expr, [])) -> Ok(expr)
    Ok(#(_, _)) -> Error("Unexpected tokens after valid expression")
    Error(msg) -> Error(msg)
  }
}

fn is_digit(token: String) -> Bool {
  result.is_ok(int.parse(token))
}

fn as_int_or(token: String, ex: Int) -> Int {
  result.unwrap(int.parse(token), ex)
}

fn parse_tokens(tokens: List(String)) -> Result(#(Expr, List(String)), String) {
  case tokens {
    [] -> Error("Unexpected EOF")
    [head, ..rest] ->
      case head {
        "(" -> parse_list([], rest)
        ")" -> Error("Unexpected ')'")
        _ ->
          case is_digit(head) {
            True -> Ok(#(Number(as_int_or(head, 0)), rest))
            False -> Ok(#(Atom(head), rest))
          }
      }
  }
}

fn flip(arr: List(ast.Expr)) -> List(ast.Expr) {
  list.reverse(arr)
}

fn parse_list(
  acc: List(Expr),
  tokens: List(String),
) -> Result(#(Expr, List(String)), String) {
  case tokens {
    [] -> Error("Unclosed list")
    [head, ..rest] ->
      case head {
        ")" -> Ok(#(List(flip(acc)), rest))
        "(" -> {
          // Parse the inner list
          case parse_list([], rest) {
            Ok(#(inner_expr, remaining)) ->
              // Continue parsing with the remaining tokens
              parse_list([inner_expr, ..acc], remaining)
            Error(msg) -> Error(msg)
          }
        }
        _ -> {
          case parse_tokens([head]) {
            Ok(#(item, _)) -> parse_list([item, ..acc], rest)
            Error(msg) -> Error(msg)
          }
        }
      }
  }
}
