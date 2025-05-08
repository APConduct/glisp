# glisp

[![Package Version](https://img.shields.io/hexpm/v/glisp)](https://hex.pm/packages/glisp)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/glisp/)

```sh
gleam add glisp@1
```
```gleam
import glisp

pub fn main() -> Nil {
  // This starts the GLisp REPL which allows you to evaluate Lisp expressions
  // Example expressions you can try:
  // (+ 1 2 3)
  // (define x 42)
  // (if (> x 10) (* x 2) (/ x 2))
  glisp.main()
}
```

Further documentation can be found at <https://hexdocs.pm/glisp>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```
