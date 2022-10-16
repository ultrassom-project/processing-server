import Vapor

public class ReconstructionAlgorithm {
    public let logger = Logger(label: "ReconstructionAlgorithm")
    public let modelUrl: URL
    public var modelMatrixRows: Int
    public var modelMatrixCols: Int
    public var modelMatrix: [Float]?
    
    public init(modelUrl: URL) {
        self.modelUrl = modelUrl
        self.modelMatrixRows = 0
        self.modelMatrixCols = 0
    }
    
    public func loadModel() {
        guard modelMatrix == nil else {
            logger.debug("Model already loaded")
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
        
        self.modelMatrix = []
        
        var rows = 0
        var cols = 0
        while (bytesRead > 0) {
            let lineAsString: String = String.init(cString: lineByteArrayPointer!)
            let lineAsFloatArray: [Float] = lineAsString.components(separatedBy: ",").map { ($0 as NSString).floatValue }
            modelMatrix?.append(contentsOf: lineAsFloatArray)
            bytesRead = getline(&lineByteArrayPointer, &lineCap, filePointer)
            
            rows += 1
            cols = lineAsFloatArray.count
        }
        
        self.modelMatrixCols = cols
        self.modelMatrixRows = rows
        
        let endDate = Date()
        
        logger.info("Model loaded in \(endDate.timeIntervalSinceReferenceDate - startDate.timeIntervalSinceReferenceDate) seconds")
    }
    
    public func unloadModel() {
        self.modelMatrix = nil
        self.modelMatrixRows = 0
        self.modelMatrixCols = 0
    }
    
    public func calculateError(A: [Float], B: [Float]) -> Float {
        return BLAS.vectorL2Norm(A) - BLAS.vectorL2Norm(B)
    }
    
    public func run(reconstructionInput: ReconstructionInput, errorConvergence: Float) -> ReconstructionOutput? {
        return nil
    }
}
