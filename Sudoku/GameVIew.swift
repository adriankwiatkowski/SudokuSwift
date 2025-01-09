import SwiftUI

struct GameView: View {
  @ObservedObject var viewModel: SudokuViewModel
  @State private var wonGameAlert = false

  var sudoku: some View {
    SudokuGridView { x, y in
      let cellIndex = y * 9 + x
      let cell = viewModel.getCell(cellIndex: cellIndex)
      viewModel.getCellColor(cellIndex: cellIndex)
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
    }
    .padding()
  }

  var inputNumbers: some View {
    HStack {
      ForEach(1 ... 9, id: \.self) { number in
        let remainingNumber = viewModel.getRemainingNumbers()[number - 1]
        Button {
          if viewModel.setSelectedCellValue(value: number) {
            wonGameAlert = true
          }
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
          
          reset
          
          sudoku
          inputNumbers
        }
        .alert("You won!", isPresented: $wonGameAlert) {
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