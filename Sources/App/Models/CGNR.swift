import Foundation

public class CGNR: ReconstructionAlgorithm {
    public func calculateError(v1: [Float], v2: [Float]) -> Float {
        return abs(BLAS.vectorL2Norm(v1) - BLAS.vectorL2Norm(v2))
    }
    
    public override func run(
        model: inout [Float]?,
        modelRows: Int,
        modelCols: Int,
        reconstructionInput: ReconstructionInput,
        errorConvergence: Float
    ) -> ReconstructionOutput? {
        guard
            let model = model,
            reconstructionInput.algorithm == .CGNR
        else {
            logger.error("Model was not initialized")
            return nil
        }
        
        var f: [Float] = Array(repeating: 0.0, count: modelCols)
        var r: [Float] = reconstructionInput.signalVector
        var z: [Float] = BLAS.multiplyMatrixByVector(transposeM: true, M: model, MRows: modelRows, MCols: modelCols, v: r)
        var p: [Float] = z
        var error: Float = Float.infinity;
        var iterations: Int = 0
        let startTime: Date = Date()

        while error > errorConvergence {
            let w: [Float] = BLAS.multiplyMatrixByVector(M: model, MRows: modelRows, MCols: modelCols, v: p)
            let alpha: Float = powf(BLAS.vectorL2Norm(z), 2) / powf(BLAS.vectorL2Norm(w), 2)
            f = BLAS.sumVectors(v1: f, v2Scale: alpha, v2: p)
            let ri = BLAS.sumVectors(v1: r, v2Scale: -alpha, v2: w)
            let zi = BLAS.multiplyMatrixByVector(transposeM: true, M: model, MRows: modelRows, MCols: modelCols, v: ri)
            let beta: Float = powf(BLAS.vectorL2Norm(zi), 2) / powf(BLAS.vectorL2Norm(z), 2)
            p = BLAS.sumVectors(v1: zi, v2Scale: beta, v2: p)
            error = self.calculateError(v1: ri, v2: r)
            r = ri
            z = zi
            iterations += 1
        }

        return ReconstructionOutput(
            input: reconstructionInput,
            outputImageArray: createImageHexMatrix(
                vector: f,
                rows: reconstructionInput.dimension.rawValue,
                cols: reconstructionInput.dimension.rawValue
            ),
            iterations: iterations,
            startTime: startTime,
            endTime: Date()
        )
    }
}
