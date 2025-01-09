import SwiftUI

struct SudokuGroupGridView<Content: View>: View {
  let borderColor: Color
  let borderSize: Double

  let content: (Int, Int) -> Content

  init(
    borderColor: Color,
    borderSize: Double,
    @ViewBuilder content: @escaping (Int, Int) -> Content
  ) {
    self.content = content
    self.borderColor = borderColor
    self.borderSize = borderSize
  }

  var body: some View {
    GeometryReader { geometry in
      VStack(spacing: 0) {
        ForEach(0 ..< 3) { y in
          HStack(spacing: 0) {
            ForEach(0 ..< 3) { x in
              content(x, y)
                .frame(
                  width: geometry.size.width / 3.0,
                  height: geometry.size.height / 3.0
                )
                .border(borderColor, width: borderSize)
            }
          }
        }
      }
      .aspectRatio(1.0, contentMode: .fit)
    }
    .aspectRatio(1.0, contentMode: .fit)
  }
}