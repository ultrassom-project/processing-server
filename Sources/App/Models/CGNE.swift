import Foundation

public class CGNE: ReconstructionAlgorithm {
    private func convergence(rNorm: Float, oldRNorm: Float, errorConvergence: Float) -> Bool {
        if (rNorm - oldRNorm) < errorConvergence {
            return true
        }

        return false
    }
    
    public override func run(
        model: inout [Float]?,
        modelRows: Int,
        modelCols: Int,
        reconstructionInput: ReconstructionInput,
        errorConvergence: Float
    ) -> ReconstructionOutput? {
        guard
            let H = model,
            reconstructionInput.algorithm == .CGNE
        else {
            logger.error("Model was not initialized")
            return nil
        }

        var r: [Float] = reconstructionInput.signalVector
        var p: [Float] = BLAS.multiplyMatrixByVector(transposeM: true, M: H, MRows: modelRows, MCols: modelCols, v: r)
        var f: [Float] = Array(repeating: 0, count: p.count)

        var iterations: Int = 0
        let startTime: Date = Date()

        while true {
            let rMultipliedByItsTranspose = BLAS.multiplyVectorByItsTranspose(r)
            let alpha = rMultipliedByItsTranspose / BLAS.multiplyVectorByItsTranspose(p)

            f = BLAS.sumVectors(v1: f, v2Scale: alpha, v2: p)

            let oldRNorm = BLAS.vectorL2Norm(r)

            let Hp = BLAS.multiplyMatrixByVector(M: H, MRows: modelRows, MCols: modelCols, v: p)
            r = BLAS.sumVectors(v1: r, v2Scale: -alpha, v2: Hp)

            let rNorm = BLAS.vectorL2Norm(r)

            if convergence(rNorm: rNorm, oldRNorm: oldRNorm, errorConvergence: errorConvergence) {
                break
            }

            let beta = BLAS.multiplyVectorByItsTranspose(r) / rMultipliedByItsTranspose

            let Htr = BLAS.multiplyMatrixByVector(transposeM: true, M: H, MRows: modelRows, MCols: modelCols, v: r)
            p = BLAS.sumVectors(v1: Htr, v2Scale: beta, v2: p)

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
