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
  case args {
    [a, b] -> {
      // Use structural equality for simplicity
      case a == b {
        True -> Ok(Number(1))
        False -> Ok(Number(0))
      }
    }
    _ -> Error("= requires exactly 2 arguments")
  }
}

fn less_than(args: List(Expr)) -> Result(Expr, String) {
  case args {
    [Number(a), Number(b)] -> {
      case a > b {
        True -> Ok(Number(1))
        False -> Ok(Number(0))
      }
    }
    [_, _] -> Error("'<' requires numeric arguments")
    _ -> Error("'<' requires exactly 2 arguments")
  }
}

fn greater_than(args: List(Expr)) -> Result(Expr, String) {
  case args {
    [Number(a), Number(b)] -> {
      case a > b {
        True -> Ok(Number(1))
        False -> Ok(Number(0))
      }
    }
    [_, _] -> Error("'>' requires numeric arguments")
    _ -> Error("'>' requires exactly 2 arguments")
  }
}

fn make_list(args: List(Expr)) -> Result(Expr, String) {
  Ok(List(args))
}

fn car(args: List(Expr)) -> Result(Expr, String) {
  case args {
    [List([head, ..])] -> {
      Ok(head)
    }
    [List([])] -> Error("car: cannot get first element of empty list")
    [_] -> Error("car: argument must be a list")
    _ -> Error("car: expected exactly one argument")
  }
}

fn cdr(args: List(Expr)) -> Result(Expr, String) {
  case args {
    [List([_, ..tail])] -> {
      Ok(List(tail))
    }
    [List([])] -> Error("cdr: cannot get rest of empty list")
    [_] -> Error("cdr: argument must be a list")
    _ -> Error("cdr: expected exactly one argument")
  }
}
