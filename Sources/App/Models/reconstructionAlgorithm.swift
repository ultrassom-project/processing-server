import Vapor

public class ReconstructionAlgorithm {
    public let logger = Logger(label: "ReconstructionAlgorithm")
    public let modelUrl: URL
    public var modelMatrix: [[Float]]?
    
    public init(modelUrl: URL) {
        self.modelUrl = modelUrl
    }
    
    public func loadModel() {
        guard modelMatrix == nil else {
            logger.error("Model already loaded")
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
        
        self.modelMatrix = []
        
        while (bytesRead > 0) {
            let lineAsString: String = String.init(cString: lineByteArrayPointer!)
            let lineAsFloatArray: [Float] = lineAsString.components(separatedBy: ",").map { ($0 as NSString).floatValue }
            modelMatrix?.append(lineAsFloatArray)
            bytesRead = getline(&lineByteArrayPointer, &lineCap, filePointer)
        }
    }
    
    public func unloadModel() {
        self.modelMatrix = nil
    }
    
    public func calculateError(A: [Float], B: [Float]) -> Float {
        return BLAS.vectorL2Norm(A) - BLAS.vectorL2Norm(B)
    }
    
    public func run(reconstructionInput: ReconstructionInput, errorConvergence: Float) -> ReconstructionOutput? {
        return nil
    }
}
