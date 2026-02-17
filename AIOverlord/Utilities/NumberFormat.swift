import Foundation

enum NumberFormat {
    static let suffixes: [String] = [
        "", "K", "M", "B", "T",
        "aa", "bb", "cc", "dd", "ee", "ff", "gg", "hh", "ii", "jj",
        "kk", "ll", "mm", "nn", "oo", "pp", "qq", "rr", "ss", "tt",
        "uu", "vv", "ww", "xx", "yy", "zz"
    ]

    static func format(_ value: Double, decimals: Int = 2) -> String {
        guard value.isFinite else { return "INF" }
        let sign = value < 0 ? "-" : ""
        var v = abs(value)
        if v < 1000 {
            return sign + String(format: "%.\(0)f", v)
        }
        var idx = 0
        while v >= 1000 && idx < suffixes.count - 1 {
            v /= 1000
            idx += 1
        }
        let fmt = "%.\(decimals)f"
        return "\(sign)\(String(format: fmt, v))\(suffixes[idx])"
    }
}
