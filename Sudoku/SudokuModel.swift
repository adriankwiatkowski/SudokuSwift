import Foundation

struct SudokuModel {
  private(set) var cells: [Cell]
  private(set) var remainingNumbers: [Int]
  private(set) var selectedSameRevealedNumberIndices = Set<Int>
  private(set) var highlightedCellIndices = Set<Int>
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
    setHighlightedCells(cellIndex: cellIndex)
    setSelectedSameRevealedNumbers(cellIndex: cellIndex)
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

  private mutating func setHighlightedCells(cellIndex: Int) {
    highlightedCellIndices.removeAll()

    let addCell: (Int, Int) -> Void { x, y in
      let index = y * 9 + x
      if index != cellIndex {
        highlightedCellIndices.insert(index)
      }
    }

    // 0 - 0 % 3 = 0
    // 1 - 1 % 3 = 0
    // 2 - 2 % 3 = 0
    // 3 - 3 % 3 = 3
    // 4 - 4 % 3 = 3
    // 5 - 5 % 3 = 3
    // 6 - 6 % 3 = 6
    // 7 - 7 % 3 = 6
    // 8 - 8 % 3 = 6
    let blockX = (cellIndex % 9) - (cellIndex % 9) % 3
    let blockY = (cellIndex / 9) - (cellIndex / 9) % 3
    for oy in 0 ..< 3 {
      for ox in 0 ..< 3 {
        addCell(blockX + ox, blockY + oy)
      }
    }

    for ox in 0 ..< 9 {
      addCell(ox, cellIndex / 9)
      addCell(cellIndex % 9, ox)
    }
  }
  
  private mutating func setHighlightedCells(cellIndex: Int) {
    selectedSameRevealedNumberIndices.removeAll()

    if let number = cells[cellIndex].number {
      for i in cells.indices {
        if cells[i].number == number {
          selectedSameRevealedNumberIndices.insert(i)
        }
      }
    }
  }
}