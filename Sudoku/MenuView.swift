import SwiftUI

struct MenuView: View {

  var onDifficultySelect: (PlayingDifficulty) -> Void

  func difficultyButton(text: String, difficulty: PlayingDifficulty) -> some View {
    Button {
      onDifficultySelect(difficulty)
    } label: {
      Text(text)
        .frame(maxWidth: .infinity)
    }
    .buttonStyle(.borderedProminent)
    .padding(.horizontal)
  }

  var body: some View {
    VStack {
      Spacer()
      Text("Sudoku")

      difficultyButton(text: "Beginner", difficulty: .beginner)
      difficultyButton(text: "Easy", difficulty: .easy)
      difficultyButton(text: "Medium", difficulty: .medium)
      difficultyButton(text: "Hard", difficulty: .hard)
      difficultyButton(text: "Very Hard", difficulty: .veryHard)

      Spacer()
    }
    .font(.largeTitle)
  }
}

#Preview {
  MenuView(onDifficultySelect: { _ in })
}