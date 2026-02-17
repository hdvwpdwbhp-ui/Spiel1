import Foundation

enum TimeUtil {
    static func now() -> Date { Date() }

    static func secondsBetween(_ a: Date, _ b: Date) -> TimeInterval {
        b.timeIntervalSince(a)
    }

    static func clamp(_ v: TimeInterval, min: TimeInterval, max: TimeInterval) -> TimeInterval {
        Swift.max(min, Swift.min(max, v))
    }
}
