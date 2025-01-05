//
//  MenuView.swift
//  Sudoku
//
//  Created by student on 17/12/24.
//

import SwiftUI

struct MenuView: View {
    
    func difficultyButton(text: String) -> some View {
        Button {
            
        } label: {
            Text(text)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .padding(.horizontal)
    }
    
    var body: some View {
        VStack {
            Text("Sudoku")
            Spacer()
            
            // Zdjecie ??
            
            difficultyButton(text: "Latwy")
            difficultyButton(text: "Sredni")
            difficultyButton(text: "Trudny")
            difficultyButton(text: "Bardzo trudny")
            
            Spacer()
        }
        .font(.largeTitle)
    }
}

#Preview {
    MenuView()
}
