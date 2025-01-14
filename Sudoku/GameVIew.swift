import SwiftUI

struct GameView: View {
  @ObservedObject var viewModel: SudokuViewModel

  func cellWithGestures(x: Int, y: Int) -> some View {
    let cellIndex = y * 9 + x
    let cell = viewModel.getCell(cellIndex: cellIndex)

    return viewModel.getCellColor(cellIndex: cellIndex)
      .overlay {
        Text(viewModel.getCellValue(cellIndex: cellIndex))
          .bold(!cell.isModifiable)
          .font(.system(size: Constants.FontSize.large))
          .minimumScaleFactor(Constants.FontSize.scaleFactor)
          .padding(Constants.insets)
      }
      .onTapGesture {
        viewModel.selectCell(cellIndex: cellIndex)
      }
      .gesture(
        DragGesture(minimumDistance: 20)
          .onEnded { gesture in
            handleSwipe(gesture: gesture, currentIndex: viewModel.model.selectedCellIndex ?? 0)
          }
      )
  }

  private func handleSwipe(gesture: DragGesture.Value, currentIndex: Int) {
    let horizontalAmount = gesture.translation.width
    let verticalAmount = gesture.translation.height

    if abs(horizontalAmount) > abs(verticalAmount) {
      // Horizontal swipe
      if horizontalAmount > 0 {
        // Right
        let nextIndex = min(currentIndex + 1, 80)
        if nextIndex % 9 > currentIndex % 9 {
          viewModel.selectCell(cellIndex: nextIndex)
        }
      } else {
        // Left
        let nextIndex = max(currentIndex - 1, 0)
        if nextIndex % 9 < currentIndex % 9 {
          viewModel.selectCell(cellIndex: nextIndex)
        }
      }
    } else {
      // Vertical swipe
      if verticalAmount > 0 {
        // Down
        let nextIndex = min(currentIndex + 9, 80)
        viewModel.selectCell(cellIndex: nextIndex)
      } else {
        // Up
        let nextIndex = max(currentIndex - 9, 0)
        viewModel.selectCell(cellIndex: nextIndex)
      }
    }
  }

  var sudoku: some View {
    SudokuGridView { x, y in
      cellWithGestures(x: x, y: y)
    }
    .padding()
  }

  var inputNumbers: some View {
    HStack {
      ForEach(1 ... 9, id: \.self) { number in
        let remainingNumber = viewModel.getRemainingNumbers()[number - 1]
        Button {
          _ = viewModel.setSelectedCellValue(value: number)
        } label: {
          VStack {
            Text("\(number)")
              .font(.headline)
            Text("\(remainingNumber)")
              .font(.subheadline)
          }
        }
        .buttonStyle(.borderedProminent)
        .disabled(remainingNumber == 0)
      }
    }
  }

  var reset: some View {
    Button {
      viewModel.reset()
    } label: {
      Text("Reset")
    }
  }

  var body: some View {
    if viewModel.isGenerating {
      Text("Generating...")
    } else {
      VStack {
        Text("Sudoku")
          .font(.largeTitle)
        
        Text("Difficulty: \(viewModel.getDifficultyText())")
        Text("Mistakes: \(viewModel.getMistakes())")
          .foregroundStyle(viewModel.getMistakes() > 0 ? Constants.Sudoku.mistakesColor : Constants.Sudoku.mistakesNeutralColor)
          .modifier(ShakeEffect(shake: viewModel.shouldShakeMistakes))
        
        reset
        
        sudoku
        inputNumbers
      }
      .alert("You won!", isPresented: $viewModel.showWonGameAlert) {
        Button("Reset") {
          viewModel.reset()
        }
      } message: {
        Text("You made \(viewModel.getMistakes()) mistakes")
      }
    }
  }
}

#Preview {
  GameView(viewModel: .init(difficulty: .beginner))
}
