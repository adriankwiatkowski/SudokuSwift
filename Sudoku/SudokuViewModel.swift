//
//  MemoGameViewModel.swift
//  ZSwiftMemory
//
//  Created by student on 05/11/2024.
//

import Foundation
import SwiftUI

class SudokuViewModel: ObservableObject {
  @Published private(set) var model: SudokuModel
  @Published var isGenerating = true

  init(difficulty: PlayingDifficulty) {
    model = SudokuModel(cells: [])
    isGenerating = true

    reset()
  }

  func getCellColor(cellIndex: Int) -> Color {
    return cellIndex == model.selectedCellIndex ? Color.green : Color.white
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

  func reset() {
    isGenerating = true

    DispatchQueue.global(qos: .background).async {
      let cells = SudokuGenerator.generateBoard(fieldsToReveal: 70)
      DispatchQueue.main.async {
        self.model = SudokuModel(cells: cells)
        self.isGenerating = false
      }
    }
  }

  func setSelectedCellValue(value: Int) -> Bool {
    return model.setSelectedCellValue(value: value)
  }

  func selectCell(cellIndex: Int) {
    model.selectCell(cellIndex: cellIndex)
  }

  func getMistakes() -> Int {
    model.mistakes
  }
}
