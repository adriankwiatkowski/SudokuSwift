import Foundation

struct Cell: Equatable, Identifiable {
  let id: UUID = .init()
  var number: Int?
  let correctNumber: Int
  let isModifiable: Bool
}
