import Foundation

struct FoodLog: Identifiable, Codable {
    let id: UUID
    let date: Date
    let ingredients: [Ingredient]
    let totalCalories: Int
}
