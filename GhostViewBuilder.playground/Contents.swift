import SwiftUICore

@resultBuilder
struct GhostViewBuilder {
  // 中身が空
  static func buildBlock() -> EmptyView {
    EmptyView()
  }
  
  // ただ中継するだけ
  static func buildBlock<Content>(_ content: Content) -> Content where Content: View {
    content
  }
  
  // 正常系
  static func buildBlock<each Content>(_ content: repeat each Content) -> TupleView<(repeat each Content)> where repeat each Content: View {
    TupleView((repeat each content))
  }
  
//  // ↑ これを逐一書かずに済んでいる
//  static func buildBlock<C0, C1>(_ c0: C0, _ c1: C1) -> TupleView<(C0, C1)> where C0: View, C1: View {
//    TupleView((c0, c1))
//  }
  
  
  // if
  static func buildIf<Content>(_ content: Content?) -> Content? where Content: View {
    content ?? nil
  }
  
  // if else, switch, ...etc.
  static func buildEither<TrueContent, FalseContent>(first: TrueContent) -> _ConditionalContent<TrueContent, FalseContent> where TrueContent: View, FalseContent: View {
    /// 'init(_storage:)' is deprecated: Do not use this.
    _ConditionalContent(_storage: .trueContent(first))
  }
  
  static func buildEither<TrueContent, FalseContent>(second: FalseContent) -> _ConditionalContent<TrueContent, FalseContent> where TrueContent: View, FalseContent: View {
    /// 'init(_storage:)' is deprecated: Do not use this.
    _ConditionalContent(_storage: .falseContent(second))
  }
  
  /// 🤷‍♂️
  /// Processes view content for a conditional compiler-control
  /// statement that performs an availability check.
  static func buildLimitedAvailability<Content>(_ content: Content) -> AnyView where Content: View {
    content as! AnyView
  }
}

import SwiftUI
import PlaygroundSupport

PlaygroundPage.current.setLiveView(
  VStack(spacing: 20) {
    Spacer()
    example1()
    example2(true)
    example3(-3)
  }
  .padding(.all, 64)
)

@GhostViewBuilder
func example1() -> some View {
  Text("A")
  Text("B")
  Text("C")
}

@GhostViewBuilder
func example2(_ flag: Bool) -> some View {
  if flag {
    Text("TRUE")
  }
}

@GhostViewBuilder
func example3(_ n: Int) -> some View {
  if n > 0 {
    Text("Positive")
  } else {
    Text("Non-positive")
  }
}
