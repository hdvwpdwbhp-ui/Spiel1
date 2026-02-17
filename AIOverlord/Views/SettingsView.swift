import SwiftUI

struct SettingsView: View {
    @ObservedObject var gameVM: GameViewModel
    @State private var name: String = ""
    @State private var feedback: String = ""
    @State private var sending: Bool = false
    @State private var sent: Bool = false

    var body: some View {
        NavigationView {
            Form {
                Section("Player") {
                    TextField("Overlord name", text: $name)
                    Button("Save Name") {
                        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
                        if !trimmed.isEmpty { gameVM.setPlayerName(trimmed) }
                    }
                }
                Section("Feedback") {
                    TextField("Tell us what to improve", text: $feedback, axis: .vertical)
                        .lineLimit(3...6)
                    Button(sending ? "Sending..." : "Send") {
                        Task {
                            sending = true
                            await gameVM.submitFeedback(feedback)
                            sending = false
                            sent = true
                            feedback = ""
                        }
                    }
                    .disabled(sending || feedback.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                Section("Debug") {
                    Button("Save Now") { gameVM.saveNow() }
                    Button("Grant Tokens (+500)") { gameVM.state.tokens += 500; gameVM.saveNow() }
                }
            }
            .navigationTitle("Settings")
            .onAppear { name = gameVM.state.playerName }
            .alert("Sent", isPresented: $sent) { Button("OK") {} } message: { Text("Thanks!") }
        }
    }
}
