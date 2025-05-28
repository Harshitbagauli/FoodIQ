
import SwiftUI

struct AnimatedBackground: View {
    @State private var animate = false

    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.accentColor.opacity(0.7),Color.green.opacity(0.7)]),
            startPoint: animate ? .topLeading : .bottomTrailing,
            endPoint: animate ? .bottomTrailing : .topLeading
        )
        .animation(
            Animation.easeInOut(duration: 20)
                .repeatForever(autoreverses: true),
            value: animate
        )
        .onAppear {
            animate.toggle()
        }
    }
}
