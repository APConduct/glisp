import gleam/list
import gleam/string

/// Tokenize a string into a list of tokens.
///
/// This function splits the input string into tokens, ensuring that parentheses
/// are treated as separate tokens.
///
/// ## Examples
///
/// ```gleam
/// tokenize("(add 1 2)") // -> ["(", "add", "1", "2", ")"]
/// ```
pub fn tokenize(source: String) -> List(String) {
  let spaced = string.replace(source, "(", " ( ")
  let spaced = string.replace(spaced, ")", " ) ")
  string.split(spaced, " ")
  |> list.filter(fn(s) { s != "" })
}
