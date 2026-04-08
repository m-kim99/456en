import Foundation

extension Double {
    func round(_ digits: Int = 2) -> Double {
        let multiplier = pow(10, Double(digits))
        return Darwin.round(self * multiplier) / multiplier
    }
}
