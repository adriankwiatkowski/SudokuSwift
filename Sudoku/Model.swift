//
//  Model.swift
//  Sudoku
//
//  Created by student on 17/12/24.
//

import Foundation

struct Model<Content : Equatable> {

    private(set) var cells: Array<Cell>
    private(set) var points: Int = 0

    init(numberOfCells: Int, contentFactory: (Int) -> Content) {
        cells = []
        for i in 0..<numberOfCells {
            let card = Cell(id: "\(i)a", content: contentFactory(i))
            cells.append(card)
        }
    }
    
    mutating func choose(_ index: Int) {
        
    }
    
    struct Cell: Equatable, Identifiable {
        var id: String
        var isFaceUp = false
        var isMatched = false
        var visible = true
        var content: Content
    }
}
