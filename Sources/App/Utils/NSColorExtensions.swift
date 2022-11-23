import Foundation
import Cocoa


extension NSColor {
    static func hexStringFrom(white: Float) -> String {
        let whiteColor = NSColor(white: CGFloat(white), alpha: 1)
        return whiteColor.hexString
    }
    
    var hexString: String {
        guard let rgbColor = usingColorSpaceName(.calibratedRGB) else {
            return "#FFFFFF"
        }
        
        let red = Int(round(rgbColor.redComponent * 0xFF))
        let green = Int(round(rgbColor.greenComponent * 0xFF))
        let blue = Int(round(rgbColor.blueComponent * 0xFF))
        let hexString = NSString(format: "#%02X%02X%02X", red, green, blue)
        return hexString as String
    }
}
