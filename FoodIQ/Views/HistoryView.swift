import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: HistoryViewModel

    var body: some View {
        ZStack {
            // Reuse the animated gradient background from MainView style
            AnimatedBackground()
                .ignoresSafeArea()

            List {
                ForEach(viewModel.logs) { log in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(log.date, style: .date)
                                .font(.headline)
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(log.totalCalories) cal")
                                .font(.headline)
                                .foregroundColor(.yellow)
                        }

                        Divider()
                            .background(Color.white.opacity(0.7))

                        ForEach(log.ingredients) { ing in
                            HStack {
                                Text(ing.name)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                Spacer()
                                Text("\(ing.calories) cal")
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        }
                    }
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [Color.purple.opacity(0.8), Color.blue.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
                    .listRowBackground(Color.clear)
                    .padding(.vertical, 8)
                }
            }
            .listStyle(PlainListStyle())
            .background(Color.clear)
            .navigationTitle("History")
        }
    }
}

