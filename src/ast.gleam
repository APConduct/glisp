import gleam/int
import gleam/list
import gleam/string

pub type Expr {
  Atom(String)
  Number(Int)
  List(List(Expr))
  Builtin(fn(List(Expr)) -> Result(Expr, String))
}

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
