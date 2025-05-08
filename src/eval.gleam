import ast.{type Expr, Atom, Builtin, List, Number, expr_to_string}
import environment.{type Env}
import gleam/list
import gleam/result

/// Evaluate an expression in the given environment
pub fn eval(expr: Expr, env: Env) -> Result(Expr, String) {
  case expr {
    Number(_) -> Ok(expr)
    Atom(name) -> environment.get(env, name)
    Builtin(_) -> Ok(expr)
    List(elements) -> {
      case elements {
        [] -> Ok(expr)
        [Atom("define"), Atom(name), value_expr] -> {
          eval(value_expr, env)
          |> result.map(fn(value) {
            let new_env = environment.set(env, name, value)
            value
          })
        }
        [Atom("if"), condition, then_expr, else_expr] -> {
          eval(condition, env)
          |> result.then(fn(cond_val) {
            case is_truthy(cond_val) {
              True -> eval(then_expr, env)
              False -> eval(else_expr, env)
            }
          })
        }
        [func_expr, ..args] -> {
          eval(func_expr, env)
          |> result.then(fn(func) {
            eval_list(args, env)
            |> result.then(fn(evaluated_args) {
              apply_function(func, evaluated_args)
            })
          })
        }
      }
    }
  }
}

/// Evaluate a list of expressions
fn eval_list(exprs: List(Expr), env: Env) -> Result(List(Expr), String) {
  list.try_map(exprs, fn(expr) { eval(expr, env) })
}

fn apply_function(func: Expr, args: List(Expr)) -> Result(Expr, String) {
  case func {
    Builtin(fn_impl) -> fn_impl(args)
    _ -> Error("Not a function " <> expr_to_string(func))
  }
}

fn is_truthy(expr: Expr) -> Bool {
  case expr {
    Number(0) -> False
    List([]) -> False
    _ -> True
  }
}
