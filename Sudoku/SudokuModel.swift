import Foundation

struct SudokuModel {
  private(set) var cells: [Cell]
  private(set) var remainingNumbers: [Int]
  private(set) var selectedCellIndex: Int?
  private(set) var mistakes: Int = 0
  private(set) var unrevealedFields: Int

  init(cells: [Cell]) {
    remainingNumbers = Array(repeating: 9, count: 9)
    var unreavealedFields = 0

    for cell in cells {
      if let number = cell.number {
        remainingNumbers[number - 1] -= 1
      } else {
        unreavealedFields += 1
      }
    }

    self.cells = cells
    unrevealedFields = unreavealedFields
  }

  mutating func selectCell(cellIndex: Int) {
    selectedCellIndex = cellIndex
  }

  mutating func setSelectedCellValue(value: Int) -> Bool {
    if let selectedIndex = selectedCellIndex {
      var cell = cells[selectedIndex]
      if cell.isModifiable, cell.number == nil {
        if value == cell.correctNumber {
          cell.number = value
          cells[selectedIndex] = cell
          unrevealedFields -= 1
          remainingNumbers[value - 1] -= 1
          return unrevealedFields == 0
        } else {
          mistakes += 1
        }
      }
    }
    return false
  }
}