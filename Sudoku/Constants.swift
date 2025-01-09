enum Constants {
  enum Sudoku {
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
