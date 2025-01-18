import SwiftUI

// https://stackoverflow.com/questions/56874133/use-hex-color-in-swiftui

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// https://stackoverflow.com/questions/73064252/how-to-mix-two-colors-in-switui
// The original answer does not handle cases where there might be no color components.
// For example black and white have only two components

extension Color {
    func mix(with color: Color, by percentage: Double) -> Color {
        let clampedPercentage = min(max(percentage, 0), 1)
        
        // Convert to NSColor and extract components safely
        let components1 = NSColor(self).cgColor.components ?? [0, 0, 0, 1] // Default to black
        let components2 = NSColor(color).cgColor.components ?? [0, 0, 0, 1] // Default to black
        
        // Handle grayscale colors (2 components: grayscale + alpha)
        let red1 = components1.count >= 3 ? components1[0] : components1[0]
        let green1 = components1.count >= 3 ? components1[1] : components1[0]
        let blue1 = components1.count >= 3 ? components1[2] : components1[0]
        let alpha1 = components1.last ?? 1
        
        let red2 = components2.count >= 3 ? components2[0] : components2[0]
        let green2 = components2.count >= 3 ? components2[1] : components2[0]
        let blue2 = components2.count >= 3 ? components2[2] : components2[0]
        let alpha2 = components2.last ?? 1
        
        // Interpolate between the components
        let red = (1.0 - clampedPercentage) * red1 + clampedPercentage * red2
        let green = (1.0 - clampedPercentage) * green1 + clampedPercentage * green2
        let blue = (1.0 - clampedPercentage) * blue1 + clampedPercentage * blue2
        let alpha = (1.0 - clampedPercentage) * alpha1 + clampedPercentage * alpha2
        
        return Color(
            red: red,
            green: green,
            blue: blue,
            opacity: alpha
        )
    }
}
