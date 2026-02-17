import SwiftUI

struct SpinWheelView: View {
    @State private var angle: Double = 0

    var body: some View {
        ZStack {
            Circle().stroke(Color.gray.opacity(0.35), lineWidth: 10)
            ForEach(0..<12, id: \.self) { i in
                Capsule()
                    .fill(Color.gray.opacity(0.25))
                    .frame(width: 6, height: 22)
                    .offset(y: -110)
                    .rotationEffect(.degrees(Double(i) * 30))
            }
            Circle().fill(Color.black.opacity(0.05)).frame(width: 40, height: 40)
            Image(systemName: "triangle.fill")
                .rotationEffect(.degrees(180))
                .offset(y: -135)
        }
        .rotationEffect(.degrees(angle))
        .animation(.easeOut(duration: 3), value: angle)
        .onAppear { angle = 0 }
    }
}
