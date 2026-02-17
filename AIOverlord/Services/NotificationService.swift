import Foundation
import UserNotifications

final class NotificationService {
    func requestPermission() async -> Bool {
        do {
            return try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            return false
        }
    }

    func scheduleNudgesIfAllowed() {
        // TODO: schedule local notifications, max 2/day
    }
}
