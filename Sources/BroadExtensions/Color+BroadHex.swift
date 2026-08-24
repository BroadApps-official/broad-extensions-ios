import SwiftUI
import UIKit

public extension Color {
    init?(broadHex: String) {
        guard let rgba = BroadRGBAColor(hex: broadHex) else {
            return nil
        }
        self.init(
            .sRGB,
            red: rgba.red,
            green: rgba.green,
            blue: rgba.blue,
            opacity: rgba.alpha
        )
    }
}

public extension UIColor {
    convenience init?(broadHex: String) {
        guard let rgba = BroadRGBAColor(hex: broadHex) else {
            return nil
        }
        self.init(
            red: rgba.red,
            green: rgba.green,
            blue: rgba.blue,
            alpha: rgba.alpha
        )
    }
}
