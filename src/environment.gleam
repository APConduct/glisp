import ast.{type Expr}
import gleam/dict

pub type Env =
  dict.Dict(String, Expr)

/// Create a new empty environment
pub fn new() -> Env {
  dict.new()
}

/// Get a value from the environment
pub fn get(env: Env, key: String) -> Result(Expr, String) {
  case dict.get(env, key) {
    Ok(value) -> Ok(value)
    Error(_) -> Error("Unknown variable: " <> key)
  }
}

/// Set a value in the environment
pub fn set(env: Env, key: String, value: Expr) -> Env {
  dict.insert(env, key, value)
}
