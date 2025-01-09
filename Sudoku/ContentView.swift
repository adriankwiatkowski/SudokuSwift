//
//  ContentView.swift
//  Sudoku
//
//  Created by student on 17/12/24.
//

import SwiftUI

struct ContentView: View {
  @State var navigationPath = NavigationPath()

  var body: some View {
    NavigationStack(path: $navigationPath) {
      MenuView(onDifficultySelect: { difficulty in
        navigationPath.append(difficulty) 
      })
      .navigationDestination(for: PlayingDifficulty.self) { difficulty in
        GameView(viewModel: SudokuViewModel(difficulty: difficulty))
      }
    }
  }
}

#Preview {
  ContentView()
}
