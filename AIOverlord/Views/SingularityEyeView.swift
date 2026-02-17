import SwiftUI

struct SingularityEyeView: View {
    let theme: Theme
    let aiLevel: Int
    let prestige: Int

    @State private var pulse: Bool = false
    @State private var rotation: Double = 0

    var body: some View {
        ZStack {
            Circle()
                .fill(theme.accent.opacity(theme.eyeGlowIntensity))
                .scaleEffect(pulse ? 1.08 : 0.95)
                .blur(radius: 18)
            Circle()
                .fill(Color.white.opacity(theme.type == .neonDark ? 0.08 : 0.14))
                .overlay(Circle().stroke(theme.accent.opacity(0.7), lineWidth: 2))
                .scaleEffect(0.9)
            ForEach(0..<3, id: \.self) { i in
                Circle()
                    .stroke(theme.accent.opacity(0.45), lineWidth: 2)
                    .scaleEffect(0.25 + Double(i) * 0.18)
                    .rotationEffect(.degrees(rotation * (i % 2 == 0 ? 1 : -1)))
            }
            Circle()
                .fill(theme.accent.opacity(0.85))
                .frame(width: 24, height: 24)
                .shadow(radius: 6)
            VStack {
                Text("AI Lv \(aiLevel)")
                    .font(.caption2)
                    .padding(6)
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
                Text("Prestige \(prestige)")
                    .font(.caption2)
                    .padding(6)
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
            }
            .offset(y: 70)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) { pulse = true }
            withAnimation(.linear(duration: 6).repeatForever(autoreverses: false)) { rotation = 360 }
        }
    }
}
