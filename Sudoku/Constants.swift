import Foundation

enum Constants {
  static let insets: CGFloat = 2

  enum FontSize {
    static let large: CGFloat = 200
    static let small: CGFloat = 10
    static let scaleFactor = small / large
  }

  enum Sudoku {
    static let mistakesNeutralColor = Color.black
    static let mistakesColor = Color.red

    static let cellBorderColor = Color.gray
    static let cellBorderSize: CGFloat = 1.0
    static let groupBorderColor = Color.black
    static let groupBorderSize: CGFloat = 2.0
    static let gridBorderColor = Color.black
    static let gridBorderSize: CGFloat = 5.0

    static let selectedCellColor = Color.green
    static let sameCellNumberColor = selectedCellColor.opacity(0.7)
    static let highlightedCellColor = Color.gray
    static let cellColor = Color.white

    enum Difficulty {
      private static let totalFields = 9 * 9
      static let beginnerRevealedFields = totalFields - 10
      static let easyRevealedFields = totalFields - 20
      static let mediumRevealedFields = totalFields - 35
      static let hardRevealedFields = totalFields - 47
      static let veryHardRevealedFields = totalFields - 56
    }
  }
}