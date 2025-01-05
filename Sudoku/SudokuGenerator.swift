private class Solver {
  private let maxSolutions: Int
  private let randomize: Bool
  private(set) var solutions = 0
  private(set) var cells: [UInt8]

  init(maxSolutions: Int, randomize: Bool, cells: [UInt8]) {
    self.maxSolutions = maxSolutions
    self.randomize = randomize
    self.cells = cells
  }

  func solve(x: Int, y: Int) -> Bool {
    if x == 0, y == 9 {
      solutions += 1
      return solutions < maxSolutions
    }

    let currentCellIndex = Self.coordinatesToIndex(x, y)

    let nextX = (x + 1) % 9
    let nextY = (x + 1) >= 9 ? (y + 1) : y

    if cells[currentCellIndex] != 0 {
      return solve(x: nextX, y: nextY)
    }

    let availableDigits = calculateAllAvailableDigits(
      x: x,
      y: y
    )
    let isDigitAvailable = { digit in
      availableDigits & (1 << (digit - 1)) != 0
    }

    if randomize {
      var digits: [UInt8] = []
      for digit in 1 ... 9 {
        if isDigitAvailable(digit) {
          digits.append(UInt8(digit))
        }
      }

      let digitsShuffled = digits.shuffled()

      for digit in digitsShuffled {
        cells[currentCellIndex] = UInt8(digit)
        if !solve(x: nextX, y: nextY) {
          return false
        }
      }

    } else {
      for digit in 1 ... 9 {
        if isDigitAvailable(digit) {
          cells[currentCellIndex] = UInt8(digit)
          if !solve(x: nextX, y: nextY) {
            return false
          }
        }
      }
    }

    cells[Self.coordinatesToIndex(x, y)] = 0

    return true
  }

  private func calculateAllAvailableDigits(x: Int, y: Int) -> UInt16 {
    var availableDigits: UInt16 = 0b1_1111_1111

    let checkField = { [self] (fieldX: Int, fieldY: Int) in
      let value = UInt16(cells[Self.coordinatesToIndex(fieldX, fieldY)])
      if value != 0 {
        availableDigits &= ~(1 << (value - 1))
      }
    }

    for i in 0 ..< 9 {
      checkField(x, i)
      checkField(i, y)
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
    let blockX = x - x % 3
    let blockY = y - y % 3

    for oy in 0 ..< 3 {
      for ox in 0 ..< 3 {
        checkField(blockX + ox, blockY + oy)
      }
    }

    return availableDigits
  }

  private static func coordinatesToIndex(_ x: Int, _ y: Int) -> Int {
    return x + y * 9
  }
}

private func createRandomCells() -> [UInt8] {
  let solver = Solver(maxSolutions: 1, randomize: true, cells: [UInt8](repeating: 0, count: 9 * 9))
  _ = solver.solve(x: 0, y: 0)
  return solver.cells
}

private func solutionCount(cells: [UInt8], maxSolutions: Int) -> Int {
  let solver = Solver(
    maxSolutions: maxSolutions,
    randomize: false,
    cells: cells
  )
  _ = solver.solve(x: 0, y: 0)
  return solver.solutions
}

private class Generator {
  private(set) var cells: [UInt8]
  private(set) var revealed: [UInt8]
  private let targetRevealed: Int

  private var iterationCount = 0

  enum GenerationStepResult {
    case ok, fail, error, iterationOverflow
  }

  init(cells: [UInt8], targetRevealed: Int) {
    self.cells = cells
    self.targetRevealed = targetRevealed

    revealed = []
    for i in 0 ..< (9 * 9) {
      revealed.append(UInt8(i))
    }
  }

  func step() -> GenerationStepResult {
    if revealed.count == targetRevealed {
      return .ok
    }

    let candidates = revealed.shuffled()
    for candidate in candidates {
      let candidateIndex = Int(candidate)

      iterationCount += 1
      if iterationCount > 110 {
        return .iterationOverflow
      }

      let previous = cells[candidateIndex]
      if previous == 0 {
        return .error
      }

      cells[candidateIndex] = 0
      if solutionCount(cells: cells, maxSolutions: 2) != 1 {
        cells[candidateIndex] = previous
        continue
      }

      let revealedIndex = revealed.firstIndex(of: candidate)!
      Self.swapRemove(list: &revealed, index: revealedIndex)

      let stepResult = step()
      if stepResult != .fail {
        return stepResult
      }

      revealed.append(candidate)
      cells[candidateIndex] = previous
    }

    return .fail
  }

  private static func swapRemove<T>(list: inout [T], index: Int) {
    let lastIndex = list.count - 1
    if lastIndex != index {
      list[index] = list[lastIndex]
    }
    list.removeLast()
  }
}

class SudokuGenerator {
  static func generateBoard(fieldsToReveal: Int) -> [Cell] {
    while true {
      let finalBoard = createRandomCells()

      let generator = Generator(cells: finalBoard, targetRevealed: fieldsToReveal)
      if generator.step() == .ok {
        return convertBoard(startingBoard: generator.cells, finalBoard: finalBoard)
      }
    }
  }

  private static func convertBoard(startingBoard: [UInt8], finalBoard: [UInt8]) -> [Cell] {
    var cells: [Cell] = []

    for i in 0 ..< (9 * 9) {
      let startingValue = startingBoard[i]
      let finalValue = finalBoard[i]

      let hasStartingValue = startingValue != 0

      cells.append(Cell(
        number: hasStartingValue ? Int(startingValue) : nil,
        correctNumber: Int(finalValue),
        isModifiable: !hasStartingValue
      ))
    }

    return cells
  }
}
