import ast.{type Expr, Builtin, List, Number}
import environment.{type Env}
import gleam/list
import gleam/result

/// Create a standard environment with built-in functions
pub fn standard_env() -> Env {
  let env =
    environment.new()
    // Arithmetic operators
    |> environment.set("+", Builtin(add))
    |> environment.set("-", Builtin(subtract))
    |> environment.set("*", Builtin(multiply))
    |> environment.set("/", Builtin(divide))
    // Comparison operators
    |> environment.set("=", Builtin(equals))
    |> environment.set("<", Builtin(less_than))
    |> environment.set(">", Builtin(greater_than))
    // List operations
    |> environment.set("list", Builtin(make_list))
    |> environment.set("car", Builtin(car))
    |> environment.set("cdr", Builtin(cdr))
  env
}

fn add(args: List(Expr)) -> Result(Expr, String) {
  args
  |> list.try_map(fn(arg) {
    case arg {
      Number(n) -> Ok(n)
      _ -> Error("Expected number in addition")
    }
  })
  |> result.map(fn(nums) { Number(list.fold(nums, 0, fn(acc, n) { acc + n })) })
}

fn subtract(args: List(Expr)) -> Result(Expr, String) {
  args
  |> list.try_map(fn(arg) {
    case arg {
      Number(n) -> Ok(n)
      _ -> Error("Expected number in subtraction")
    }
  })
  |> result.map(fn(nums) { Number(list.fold(nums, 0, fn(acc, n) { acc - n })) })
}

fn multiply(args: List(Expr)) -> Result(Expr, String) {
  args
  |> list.try_map(fn(arg) {
    case arg {
      Number(n) -> Ok(n)
      _ -> Error("Expected number in multiplication")
    }
  })
  |> result.map(fn(nums) { Number(list.fold(nums, 0, fn(acc, n) { acc * n })) })
}

fn divide(args: List(Expr)) -> Result(Expr, String) {
  args
  |> list.try_map(fn(arg) {
    case arg {
      Number(n) -> Ok(n)
      _ -> Error("Expected number in division")
    }
  })
  |> result.map(fn(nums) { Number(list.fold(nums, 0, fn(acc, n) { acc / n })) })
}

fn equals(args: List(Expr)) -> Result(Expr, String) {
  todo
}

fn less_than(args: List(Expr)) -> Result(Expr, String) {
  todo
}

fn greater_than(args: List(Expr)) -> Result(Expr, String) {
  todo
}

fn make_list(args: List(Expr)) -> Result(Expr, String) {
  todo
}

fn car(args: List(Expr)) -> Result(Expr, String) {
  todo
}

fn cdr(args: List(Expr)) -> Result(Expr, String) {
  todo
}
