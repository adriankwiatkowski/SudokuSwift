//
//  ContentView.swift
//  Sudoku
//
//  Created by student on 17/12/24.
//

import SwiftUI

struct ContentView: View {
    
    @State var showWinPopup = true
    
    var sudoku: some View {
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
        ]
        
        return LazyVGrid(columns: columns, spacing: 0) {
            ForEach(1...9, id: \.self) { _ in
                VStack {
                    ForEach(0..<3, id: \.self) { y in
                        HStack {
                            ForEach(1...3, id: \.self) { x in
                                Text("\(y * 3 + x)")
                                    .border(.gray)
                            }
                        }
                    }
                }
                .padding()
            }
        }
    }
    
    var inputNumbers: some View {
        HStack {
            ForEach(1...9, id: \.self) { number in
                Button {
                    
                } label: {
                    // Niewidoczne jak liczba jest zuzyta
                    Text("\(number)")
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
    
    var body: some View {
        VStack {
            Text("Sudoku")
                .font(.largeTitle)
            Text("Timer: \(123)s")
            
            sudoku
            inputNumbers

            Button {
                
            } label: {
                Text("Sprawdz")
            }
            
            Button {
                
            } label: {
                Text("Reset")
            }
        }
        .alert("asdf?", isPresented: $showWinPopup) {
            VStack {
                Text("Gratulacje, wygrales!")
                Text("Gra zajela 123s na poziomie bardzo trudnym")
                Button("Powroc do menu glownego") {
                    
                }
                // Popup
                // Zagraj jeszcze raz
            }
            // Inny popup jezeli zle wypelniles (haha)
            // minus wynik za kazde zle sprawdzenie + czas
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
