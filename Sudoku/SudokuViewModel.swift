import Foundation
import SwiftUI

class SudokuViewModel: ObservableObject {
  @Published private(set) var model: SudokuModel
  @Published private(set) var isWon = false
  @Published private(set) var showWonGameAlert = false
  @Published private(set) var isGenerating = true
  @Published private(set) var difficulty: PlayingDifficulty

  init(difficulty: PlayingDifficulty) {
    self.difficulty = difficulty
    model = SudokuModel(cells: [])

    reset()
  }

  func reset() {
    isWon = false
    showWonGameAlert = false
    isGenerating = true

    DispatchQueue.global(qos: .background).async {
      let cells = SudokuGenerator.generateBoard(fieldsToReveal: getFieldsToReveal())
      DispatchQueue.main.async {
        self.model = SudokuModel(cells: cells)
        self.isGenerating = false
      }
    }
  }

  func getCellColor(cellIndex: Int) -> Color {
    if cellIndex == model.selectedCellIndex {
      return Constants.Sudoku.selectedCellColor
    }
    if model.selectedSameRevealedNumberIndices.contains(cellIndex) {
      return Constants.Sudoku.sameCellNumberColor
    }
    if model.highlightedCellIndices.contains(cellIndex) {
      return Constants.Sudoku.highlightedCellColor
    }
    return Constants.Sudoku.cellColor
  }

  func getCell(cellIndex: Int) -> Cell {
    return model.cells[cellIndex]
  }

  func getCellValue(cellIndex: Int) -> String {
    let cell = model.cells[cellIndex]
    if let number = cell.number {
      return "\(number)"
    } else {
      return ""
    }
  }

  func getRemainingNumbers() -> [Int] {
    return model.remainingNumbers
  }

  func setSelectedCellValue(value: Int) -> Bool {
    let won = model.setSelectedCellValue(value: value)
    if won {
      isWon = true
      showWonGameAlert = true
    }
    return won
  }

  func selectCell(cellIndex: Int) {
    model.selectCell(cellIndex: cellIndex)
  }

  func getMistakes() -> Int {
    model.mistakes
  }

  func getDifficultyText() -> String {
    switch self.difficulty {
      case .beginner:
        return "Beginner"
      case .easy:
        return "Easy"
      case .medium:
        return "Medium"
      case .hard:
        return "Hard"
      case .veryHard:
        return "Very Hard"
      default:
        return "Unknown"
    }
  }

  private func getFieldsToReveal() -> Int {
    var fieldsToReveal = Constants.Sudoku.Difficulty.beginnerRevealedFields
    switch self.difficulty {
      case .beginner:
        fieldsToReveal = Constants.Sudoku.Difficulty.beginnerRevealedFields
      case .easy:
        fieldsToReveal = Constants.Sudoku.Difficulty.easyRevealedFields
      case .medium:
        fieldsToReveal = Constants.Sudoku.Difficulty.mediumRevealedFields
      case .hard:
        fieldsToReveal = Constants.Sudoku.Difficulty.hardRevealedFields
      case .veryHard:
        fieldsToReveal = Constants.Sudoku.Difficulty.veryHardRevealedFields
    }
    return fieldsToReveal
  }
}