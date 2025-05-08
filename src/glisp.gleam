import glisp/repl

/// Main entry point for the REPL application.
/// This function initializes and runs the Read-Eval-Print Loop,
/// providing an interactive environment for command execution.
pub fn main() -> Nil {
  repl.main_repl()
}
