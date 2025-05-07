pub type Expr {
  Atom(String)
  Number(Int)
  List(List(Expr))
  Builtin(fn(List(Expr)) -> Result(Expr, String))
}
