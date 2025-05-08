import gleam/list
import gleam/result
import glisp/ast.{type Expr, Builtin, List, Number}
import glisp/environment.{type Env}

/// Create a standard environment with built-in functions
///
/// This includes arithmetic operators (+, -, *, /), comparison operators (=, <, >),
/// list manipulation functions (list, car, cdr, cons, length, null?), and logical
/// operations (not).
///
/// Returns an `Env` that can be used as the basis for evaluating expressions.
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
    // More functions
    |> environment.set("cons", Builtin(cons))
    |> environment.set("length", Builtin(length))
    |> environment.set("null?", Builtin(null))
    |> environment.set("not", Builtin(not))
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
  case args {
    [] -> Error("- requires at least one argument")
    [Number(first), ..rest] -> {
      rest
      |> list.try_map(fn(arg) {
        case arg {
          Number(n) -> Ok(n)
          _ -> Error("Expected number in subtraction")
        }
      })
      |> result.map(fn(nums) {
        case list.length(nums) {
          // Unary minus (negate)
          0 -> Number(0 - first)
          // Subtraction from first argument
          _ -> Number(list.fold(nums, first, fn(acc, n) { acc - n }))
        }
      })
    }
    _ -> Error("Expected number as first argument to -")
  }
}

fn multiply(args: List(Expr)) -> Result(Expr, String) {
  args
  |> list.try_map(fn(arg) {
    case arg {
      Number(n) -> Ok(n)
      _ -> Error("Expected number in multiplication")
    }
  })
  |> result.map(fn(nums) { Number(list.fold(nums, 1, fn(acc, n) { acc * n })) })
}

fn divide(args: List(Expr)) -> Result(Expr, String) {
  case args {
    [] -> Error("/ requires at least one argument")
    [Number(first), ..rest] -> {
      rest
      |> list.try_map(fn(arg) {
        case arg {
          Number(n) ->
            case n {
              0 -> Error("Division by zero")
              _ -> Ok(n)
            }
          _ -> Error("Expected number in division")
        }
      })
      |> result.map(fn(nums) {
        case list.length(nums) {
          // Unary division (reciprocal)
          0 -> Number(1 / first)
          // Division
          _ -> Number(list.fold(nums, first, fn(acc, n) { acc / n }))
        }
      })
    }
    _ -> Error("Expected number as first argument to /")
  }
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

fn cons(args: List(Expr)) -> Result(Expr, String) {
  case args {
    [head, List(tail)] -> {
      Ok(List([head, ..tail]))
    }
    [_, _] -> Error("cons: second argument must be a list")
    _ -> Error("cons: expected exactly two arguments")
  }
}

fn length(args: List(Expr)) -> Result(Expr, String) {
  case args {
    [List(elements)] -> {
      Ok(Number(list.length(elements)))
    }
    [_] -> Error("length: argunment must be a list")
    _ -> Error("length: expected exactly one argument")
  }
}

fn null(args: List(Expr)) -> Result(Expr, String) {
  case args {
    [List([])] -> Ok(Number(1))
    // True if empty
    [List(_)] -> Ok(Number(0))
    // False if has elements
    [_] -> Error("null?: argument must be a list")
    _ -> Error("null?: expected exactly one argument")
  }
}

fn not(args: List(Expr)) -> Result(Expr, String) {
  case args {
    [Number(0)] -> Ok(Number(1))
    [_] -> Ok(Number(0))
    _ -> Error("not: expected exactly one argument")
  }
}
