import Foundation

struct Ingredient: Identifiable, Codable {
    let id: UUID
    var name: String
    var calories: Int
}
