//
//  ContentView.swift
//  Sudoku
//
//  Created by student on 17/12/24.
//

import SwiftUI

enum PlayingDifficulty {
  case A, B
}

struct PlayingView: View {
  @StateObject var sudokuViewModel: SudokuViewModel

  var body: some View {
    VStack {
      if sudokuViewModel.isGenerating {
        Text("Generating...")
      } else {
        GameView(viewModel: sudokuViewModel)
      }
    }
  }
}

struct ContentView: View {
  @State var navigationPath = NavigationPath()

  var body: some View {
    NavigationStack(path: $navigationPath) {
      VStack {
        Button("asfd") {
          navigationPath.append(PlayingDifficulty.A)
        }

        Button("asdf2") {
          navigationPath.append(PlayingDifficulty.B)
        }
      }
      .navigationDestination(for: PlayingDifficulty.self) { difficulty in
        PlayingView(sudokuViewModel: SudokuViewModel(difficulty: difficulty))
      }
    }
  }
}

#Preview {
  ContentView()
}
