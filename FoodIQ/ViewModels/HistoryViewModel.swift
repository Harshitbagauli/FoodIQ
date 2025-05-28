import SwiftUI

class HistoryViewModel: ObservableObject {
    @Published var logs: [FoodLog] = []

    func addLog(_ log: FoodLog) {
        logs.append(log)
    }
}
