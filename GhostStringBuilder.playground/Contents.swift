
// 通常の Swift においては複数式は「個別に評価される」ものとして扱われる。
func f() -> String {
  "A"
  "B"
  return ""
}

f()

// ❌ 明示的な返却値がない場合はエラー扱いとなる。
// func f() -> String {
//   "A"
//   "B" // Missing return in global function expected to return 'String'
// }

// ⭕ 単一式の場合は、その式を暗黙に返す構文として扱われるため、エラー扱いとならず、評価結果が素直に返却される。
func g() -> String {
  "A"
}

g() // "A"

// @resultBuilder を使用すると、構文解析後のフェーズに介入し、ユーザー定義の規則で「構文木の意味づけ（構文解釈）」を差し替えることができる。
// ソースコード → 字句解析（Lexing） → 構文解析（Parsing to AST） → \\ HERE // → 型推論・意味解析（Type checking / Semantic analysis） → 中間言語生成（SIL → LLVM IR） → コンパイル

@resultBuilder
struct GhostStringBuilder {
  static func buildBlock(_ components: String...) -> String {
    components.joined()
  }
}

// Result builder attribute 'GhostStringBuilder' can only be applied to a constant if it defines a getter
// @resultBuilder は、
// ① attribute であるため、宣言（declaration）にのみ付帯できる。
// ② builder 規則で再解釈する都合上、body（= ユーザー定義可能なコードブロック）を持つ宣言にのみ付帯できる。
//

// ❌ closure literal
// let f = @GhostStringBuilder {
//   "A"
//   "B"
// }

// ❌ type annotation
// let f: @GhostStringBuilder () -> String = {
//   "A"
//   "B"
// }

// ❌ stored property
// @GhostStringBuilder
// let f = {
//   "A"
//   "B"
// }

// ⭕ computed property
@GhostStringBuilder
var h: String {
  "A"
  "B"
}

h // "AB"

// ⭕ function
@GhostStringBuilder
func i() -> String {
  "A"
  "B"
}

i() // "AB"

// ⭕ function parameter
func j(@GhostStringBuilder _ closure: () -> String) -> String {
  closure()
}

j {
  "A"
  "B"
} // "AB"





