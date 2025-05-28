import Foundation
import Vision
import CoreML
import CoreImage

class OpenAIService {
    static let shared = OpenAIService()
    private init() {}
    
    // MARK: - Public Method
    func analyzeFoodImage(imageData: Data) async -> (ingredients: [Ingredient], totalCalories: Int) {
        guard let ciImage = CIImage(data: imageData) else {
            return ([Ingredient(id: UUID(), name: "", calories: 0)], 0)
        }
        
        do {
            let label = try await recognizeImage(image: ciImage)
            print("Classification Result: \(label)")
            
            // You can add more logic to determine calories based on label
            return ([Ingredient(id: UUID(), name: label, calories: 105)], 105)
        } catch {
            print("Image recognition failed with error: \(error)")
            return ([Ingredient(id: UUID(), name: "Unknown", calories: 0)], 0)
        }
    }
    
    // MARK: - Vision (Async version)
    func recognizeImage(image: CIImage) async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            guard let model = try? VNCoreMLModel(for: MobileNetV2().model) else {
                continuation.resume(throwing: NSError(domain: "MLModelError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Model initialization failed"]))
                return
            }
            
            let request = VNCoreMLRequest(model: model) { vnRequest, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                if let results = vnRequest.results as? [VNClassificationObservation], let topResult = results.first {
                    continuation.resume(returning: topResult.identifier)
                } else {
                    continuation.resume(throwing: NSError(domain: "ClassificationError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not classify image"]))
                }
            }
            
            let handler = VNImageRequestHandler(ciImage: image)
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    try handler.perform([request])
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
