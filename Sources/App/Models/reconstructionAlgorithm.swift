import Vapor
import Cocoa
import Foundation

public class ReconstructionAlgorithm {
    public let logger = Logger(label: "ReconstructionAlgorithm")
    
    public init() {}
    
    public func createImageHexMatrix(vector: [Float], rows: Int, cols: Int) -> [[String]] {
        var convertedArray: [[String]] = Array(repeating: Array(repeating: "", count: cols), count: rows);
        let upperLimit: Float = 1
        let lowerLimit: Float = 0
        let newRange: Float = upperLimit - lowerLimit
        
        guard let vectorLimits = vector.minAndMax() else {
            return []
        }
        
        let oldRange: Float = vectorLimits.max - vectorLimits.min
        
        var k: Int = 0
        for i in 0..<rows {
            for j in 0..<cols {
                let whiteColor = (((vector[k] - vectorLimits.min) * newRange) / oldRange) + lowerLimit
                convertedArray[j][i] = NSColor.hexStringFrom(white: whiteColor)
                k += 1
            }
        }
        
        return convertedArray
    }
    
    public func run(model: inout [Float]?, modelRows: Int, modelCols: Int, reconstructionInput: ReconstructionInput, errorConvergence: Float) -> ReconstructionOutput? {
        return nil
    }
}
