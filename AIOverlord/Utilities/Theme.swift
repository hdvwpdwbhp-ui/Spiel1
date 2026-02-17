import SwiftUI

enum ThemeType: String, Codable {
    case bright
    case industrial
    case planetary
    case neonDark
    case procedural
}

struct Theme {
    let type: ThemeType

    var background: Color {
        switch type {
        case .bright: return Color(.systemBackground)
        case .industrial: return Color(.secondarySystemBackground)
        case .planetary: return Color(.systemBackground)
        case .neonDark: return Color.black
        case .procedural: return Color(.systemBackground)
        }
    }

    var accent: Color {
        switch type {
        case .bright: return .blue
        case .industrial: return .orange
        case .planetary: return .green
        case .neonDark: return .pink
        case .procedural: return .purple
        }
    }

    var eyeGlowIntensity: Double {
        switch type {
        case .bright: return 0.30
        case .industrial: return 0.45
        case .planetary: return 0.55
        case .neonDark: return 0.80
        case .procedural: return 0.65
        }
    }
}
