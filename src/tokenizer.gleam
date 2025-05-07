import gleam/list
import gleam/string

pub fn tokenize(source: String) -> List(String) {
  let spaced = string.replace(source, "(", " ( ")
  let spaced = string.replace(spaced, ")", " ) ")
  string.split(spaced, " ")
  |> list.filter(fn(s) { s != "" })
}
