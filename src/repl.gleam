import ast
import environment
import eval
import gleam/io
import gleam/result
import gleam/string
import input
import parser
import stdlib
import tokenizer

/// Starts an interactive REPL (Read-Eval-Print Loop) for the GLisp interpreter.
///
/// This function initializes the standard environment, displays a welcome message,
/// and allows users to input Lisp expressions for immediate evaluation.
/// The loop continues until the user types 'exit'.
pub fn main_repl() -> Nil {
  io.println("Welcome to GLisp - A Lisp interpreter in Gleam!")
  io.println("Type expressions to evaluate, or 'exit' to quit.")

  let env = stdlib.standard_env()
  repl_loop(env)
}

fn repl_loop(env: environment.Env) -> Nil {
  let in = result.unwrap(input.input(prompt: "> "), "")

  case string.trim(in) {
    "exit" -> {
      io.println("Goodbye!")
      Nil
    }
    "" -> repl_loop(env)
    in -> {
      let res =
        tokenizer.tokenize(in)
        |> parser.parse
        |> result.then(fn(expr) { eval.eval(expr, env) })
      case res {
        Ok(value) -> io.println(ast.expr_to_string(value))
        Error(err) -> io.println("Error: " <> err)
      }
      repl_loop(env)
    }
  }
}
