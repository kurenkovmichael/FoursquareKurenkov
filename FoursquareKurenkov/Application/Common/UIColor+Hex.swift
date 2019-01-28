import Foundation
import UIKit

extension UIColor {

    convenience init(hexString: String) {
        let hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)

        let scanner = Scanner(string: hexString)
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }

        var color: UInt32 = 0
        scanner.scanHexInt32(&color)

        let mask = 0x000000FF
        let red   = Int(color >> 16) & mask
        let green = Int(color >> 8)  & mask
        let blue  = Int(color)       & mask

        self.init(red: CGFloat(red) / 255.0,
                  green: CGFloat(green) / 255.0,
                  blue: CGFloat(blue) / 255.0,
                  alpha: 1)
    }

}
