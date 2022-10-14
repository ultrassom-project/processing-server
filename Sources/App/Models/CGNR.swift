import Foundation

public class CGNR {
    private var modelMatrix: [[Float]]?
    
    public init() {
        self.modelMatrix = nil
    }
    
    public func loadModel(fileUrl: URL) {
        if modelMatrix == nil {
            guard FileManager.default.fileExists(atPath: fileUrl.path) else {
                preconditionFailure("File \(fileUrl.absoluteString) is missing")
            }
            
            guard let filePointer: UnsafeMutablePointer<FILE> = fopen(fileUrl.path, "r") else {
                preconditionFailure("Could not open file at \(fileUrl.absoluteString)")
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
        guard
            let modelMatrix = self.modelMatrix,
            let firstRow = modelMatrix.first,
            reconstructionInput.algorithm == Algorithm.CGNR
        else {
            print("Model was not initialized")
            return nil
        }
        
        let modelCols: Int = firstRow.count
        
        var f: [Float] = Array(repeating: 0.0, count: modelCols)
        var r: [Float] = reconstructionInput.signalVector
        var z: [Float] = BLAS.multiplyMatrixByVector(transposeM: true, alpha: 1, M: modelMatrix, A: r)
        var p: [Float] = z
        var error: Float = Float.infinity;
        var iterations: Int = 0
        let startTime: Date = Date()
        
        while error > errorConvergence {
            let w: [Float] = BLAS.multiplyMatrixByVector(transposeM: false, alpha: 1, M: modelMatrix, A: p)
            let alpha: Float = powf(BLAS.vectorL2Norm(z), 2) / powf(BLAS.vectorL2Norm(w), 2)
            f = BLAS.sumVectors(alpha: 1, A: f, beta: alpha, B: p)
            let ri = BLAS.sumVectors(alpha: 1, A: r, beta: -alpha, B: w)
            let zi = BLAS.multiplyMatrixByVector(transposeM: true, alpha: 1, M: modelMatrix, A: ri)
            let beta: Float = powf(BLAS.vectorL2Norm(zi), 2) / powf(BLAS.vectorL2Norm(z), 2)
            p = BLAS.sumVectors(alpha: 1, A: zi, beta: beta, B: p)
            error = self.calculateError(A: ri, B: r)
            r = ri
            z = zi
            iterations += 1
        }
        
        return ReconstructionOutput(
            input: reconstructionInput,
            outputVector: f,
            iterations: iterations,
            startTime: startTime,
            endTime: Date()
        )
    }
}
