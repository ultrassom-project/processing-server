import Vapor
import Cocoa
import Foundation

public class ReconstructionAlgorithm {
    public let logger = Logger(label: "ReconstructionAlgorithm")
    public let modelUrl: URL
    public var modelRows: Int
    public var modelCols: Int
    public var model: [Float]?
    
    public init(modelUrl: URL) {
        self.modelUrl = modelUrl
        self.modelRows = 0
        self.modelCols = 0
    }
    
    public func loadModel() {
        guard model == nil else {
            return
        }

        guard FileManager.default.fileExists(atPath: modelUrl.path) else {
            logger.error("Model file \(modelUrl.absoluteString) is missing")
            return
        }
        
        guard let filePointer: UnsafeMutablePointer<FILE> = fopen(modelUrl.path, "r") else {
            logger.error("Could not open model file at \(modelUrl.absoluteString)")
            return
        }
        
        var lineByteArrayPointer: UnsafeMutablePointer<CChar>? = nil
        
        defer {
            fclose(filePointer)
            lineByteArrayPointer?.deallocate()
        }
        
        var lineCap: Int = 0
        var bytesRead = getline(&lineByteArrayPointer, &lineCap, filePointer)
        
        let startDate = Date()
        self.model = []
        
        var rows = 0
        var cols = 0
        while (bytesRead > 0) {
            let lineAsString: String = String.init(cString: lineByteArrayPointer!)
            let lineAsFloatArray: [Float] = lineAsString.components(separatedBy: ",").map { ($0 as NSString).floatValue }
            model?.append(contentsOf: lineAsFloatArray)
            bytesRead = getline(&lineByteArrayPointer, &lineCap, filePointer)
            
            rows += 1
            cols = lineAsFloatArray.count
        }
        
        self.modelRows = rows
        self.modelCols = cols
        
        let duration = Date().timeIntervalSince(startDate)
        logger.info("Model loaded in \(duration) seconds")
    }
    
    public func unloadModel() {
        self.model = nil
        self.modelRows = 0
        self.modelCols = 0
    }
    
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
                convertedArray[i][j] = NSColor.hexStringFrom(white: whiteColor)
                k += 1
            }
        }
        
        return convertedArray
    }
    
    public func calculateError(A: [Float], B: [Float]) -> Float {
        return abs(BLAS.vectorL2Norm(A) - BLAS.vectorL2Norm(B))
    }
    
    public func run(reconstructionInput: ReconstructionInput, errorConvergence: Float) -> ReconstructionOutput? {
        return nil
    }
}
