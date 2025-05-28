import SwiftUI

class FoodAnalysisViewModel: ObservableObject {
    @Published var ingredients: [Ingredient] = []
    @Published var totalCalories: Int = 0

    func analyzeImage(_ image: UIImage) async {
        guard let imageData = image.jpegData(compressionQuality: 0.6) else { return }
        let result = await OpenAIService.shared.analyzeFoodImage(imageData: imageData)
        
        DispatchQueue.main.async {
            self.ingredients = result.ingredients
            self.totalCalories = result.totalCalories
        }
    }

    func updateIngredient(_ ingredient: Ingredient, calories: Int) {
        if let index = ingredients.firstIndex(where: { $0.id == ingredient.id }) {
            ingredients[index].calories = calories
            totalCalories = ingredients.reduce(0) { $0 + $1.calories }
        }
    }
}
