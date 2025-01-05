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
            .font(.system(size: 200))
            .minimumScaleFactor(0.01)
            .padding(2.0)
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
        Button {
          if viewModel.setSelectedCellValue(value: number) {
            wonGameAlert = true
          }
        } label: {
          Text("\(number)")
        }
        .buttonStyle(.borderedProminent)
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
    VStack {
      Text("Sudoku")
        .font(.largeTitle)

      Text("Mistakes: \(viewModel.getMistakes())")
        .foregroundStyle(viewModel.getMistakes() > 0 ? Color.red : Color.black)

      reset

      sudoku
      inputNumbers
    }
    .alert("You won!", isPresented: $wonGameAlert) {
      Button("Reset") {
        viewModel.reset()
      }
    }
  }
}
