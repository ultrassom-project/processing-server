import Foundation

public class CGNE: ReconstructionAlgorithm {
    private func convergence(rNorm: Float, oldRNorm: Float) -> Bool {
        if (rNorm - oldRNorm) < 0.0001 {
            return true
        }

        return false
    }
    
//    public override func run(
//        reconstructionInput: ReconstructionInput,
//        errorConvergence: Float
//    ) -> ReconstructionOutput? {
//        guard
//            let H = self.model,
//            reconstructionInput.algorithm == .CGNE
//        else {
//            logger.error("Model was not initialized")
//            return nil
//        }
//
//        var r: [Float] = reconstructionInput.signalVector
//        var p: [Float] = BLAS.multiplyMatrixByVector(matrix: H, rows: modelRows, columns: modelCols, transposeMatrix: true, vector: r)
//        var f: [Float] = Array(repeating: 0, count: p.count)
//
//        var iterations: Int = 0
//        let startTime: Date = Date()
//
//        while true {
//            let rMultipliedByItsTranspose = BLAS.multiplyVectorByItsTranspose(r)
//            let alpha = rMultipliedByItsTranspose / BLAS.multiplyVectorByItsTranspose(p)
//
//            f = BLAS.sumVectors(f, p, beta: alpha)
//
//            let oldRNorm = BLAS.euclideanNorm(of: r)
//
//            let Hp = BLAS.multiplyMatrixByVector(matrix: H, rows: modelRows, columns: modelCols, vector: p)
//            r = BLAS.sumVectors(r, Hp, beta: -alpha)
//
//            let rNorm = BLAS.euclideanNorm(of: r)
//
//            if convergence(rNorm: rNorm, oldRNorm: oldRNorm) {
//                break
//            }
//
//            let beta = BLAS.multiplyVectorByItsTranspose(r) / rMultipliedByItsTranspose
//
//            let Htr = BLAS.multiplyMatrixByVector(matrix: H, rows: modelRows, columns: modelCols, transposeMatrix: true, vector: r)
//            p = BLAS.sumVectors(Htr, p, beta: beta)
//
//            iterations += 1
//        }
//
//        return ReconstructionOutput(
//            input: reconstructionInput,
//            outputImageArray: createImageHexMatrix(vector: f, rows: 30, cols: 30),
//            iterations: iterations,
//            startTime: startTime,
//            endTime: Date()
//        )
//    }
}
