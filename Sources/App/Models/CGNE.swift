import Foundation

public class CGNE {
    private let modelUrl: URL;
    private var modelMatrix: [[Float]]?
    
    public init(modelUrl: URL) {
        self.modelMatrix = nil
        self.modelUrl = modelUrl
    }
    
    public func loadModel() {
        if modelMatrix == nil {
            guard FileManager.default.fileExists(atPath: modelUrl.path) else {
                preconditionFailure("File \(modelUrl.absoluteString) is missing")
            }
            
            guard let filePointer: UnsafeMutablePointer<FILE> = fopen(modelUrl.path, "r") else {
                preconditionFailure("Could not open file at \(modelUrl.absoluteString)")
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
    }
    
    public func unloadModel() {
        self.modelMatrix = nil
    }
    
    private func calculateError(A: [Float], B: [Float]) -> Float {
        return BLAS.vectorL2Norm(A) - BLAS.vectorL2Norm(B)
    }
    
    public func run(reconstructionInput: ReconstructionInput, errorConvergence: Float) -> ReconstructionOutput? {
        return ReconstructionOutput(
            input: reconstructionInput,
            outputVector: [],
            iterations: 0,
            startTime: Date(),
            endTime: Date()
        )
    }
}
