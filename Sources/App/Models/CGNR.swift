import Foundation

public class CGNR: ReconstructionAlgorithm {
    public init() {
        super.init(modelUrl: URL.fromFilesFolder(name: "cgnr", ext: "csv"))
    }
    
    public override func run(reconstructionInput: ReconstructionInput, errorConvergence: Float) -> ReconstructionOutput? {
        return ReconstructionOutput(input: reconstructionInput, outputVector: reconstructionInput.signalVector, iterations: 10, startTime: Date(), endTime: Date())
        
//        guard
//            let modelMatrix = self.modelMatrix,
//            let firstRow = modelMatrix.first,
//            reconstructionInput.algorithm == .CGNR
//        else {
//            print("Model was not initialized")
//            return nil
//        }
//
//        let modelCols: Int = firstRow.count
//
//        var f: [Float] = Array(repeating: 0.0, count: modelCols)
//        var r: [Float] = reconstructionInput.signalVector
//        var z: [Float] = BLAS.multiplyMatrixByVector(transposeM: true, alpha: 1, M: modelMatrix, A: r)
//        var p: [Float] = z
//        var error: Float = Float.infinity;
//        var iterations: Int = 0
//        let startTime: Date = Date()
//
//        while error > errorConvergence {
//            let w: [Float] = BLAS.multiplyMatrixByVector(transposeM: false, alpha: 1, M: modelMatrix, A: p)
//            let alpha: Float = powf(BLAS.vectorL2Norm(z), 2) / powf(BLAS.vectorL2Norm(w), 2)
//            f = BLAS.sumVectors(alpha: 1, A: f, beta: alpha, B: p)
//            let ri = BLAS.sumVectors(alpha: 1, A: r, beta: -alpha, B: w)
//            let zi = BLAS.multiplyMatrixByVector(transposeM: true, alpha: 1, M: modelMatrix, A: ri)
//            let beta: Float = powf(BLAS.vectorL2Norm(zi), 2) / powf(BLAS.vectorL2Norm(z), 2)
//            p = BLAS.sumVectors(alpha: 1, A: zi, beta: beta, B: p)
//            error = self.calculateError(A: ri, B: r)
//            r = ri
//            z = zi
//            iterations += 1
//        }
//
//        return ReconstructionOutput(
//            input: reconstructionInput,
//            outputVector: f,
//            iterations: iterations,
//            startTime: startTime,
//            endTime: Date()
//        )
    }
}
