import SwiftUI

struct SudokuGridView<Content: View>: View {
  let content: (Int, Int) -> Content

  init(
    @ViewBuilder content: @escaping (Int, Int) -> Content
  ) {
    self.content = content
  }

  var body: some View {
    SudokuGroupGridView(borderColor: Constants.Sudoku.groupBorderColor, borderSize: Constants.Sudoku.groupBorderSize) { outerX, outerY in
      SudokuGroupGridView(borderColor: Constants.Sudoku.cellBorderColor, borderSize: Constants.Sudoku.cellBorderSize) { innerX, innerY in
        let x = outerX * 3 + innerX
        let y = outerY * 3 + innerY
        content(x, y)
      }
    }
    .border(Constants.Sudoku.gridBorderColor, width: Constants.Sudoku.gridBorderSize)
  }
}