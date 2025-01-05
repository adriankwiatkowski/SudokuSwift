import SwiftUI

struct SudokuGridView<Content: View>: View {
  let content: (Int, Int) -> Content

  init(
    @ViewBuilder content: @escaping (Int, Int) -> Content
  ) {
    self.content = content
  }

  var body: some View {
    SudokuGroupGridView(borderColor: .black, borderSize: 2.0) { outerX, outerY in
      SudokuGroupGridView(borderColor: .gray, borderSize: 1.0) { innerX, innerY in
        let x = outerX * 3 + innerX
        let y = outerY * 3 + innerY
        content(x, y)
      }
    }
    .border(.black, width: 5.0)
  }
}
