import Foundation
import Accelerate

public class BLAS {
    /**
     alpha  -> scalar
     A      -> vector
     
     return -> alpha * A
     */
    public static func scaleVector(alpha: Float, A: [Float]) -> [Float] {
        var va: [Float] = A
        
        // Multiplies each element of a vector by a constant (single-precision).
        cblas_sscal(
            Int32(A.count),     // Number of elements to scale.
            alpha,              // The constant to multiply by.
            &va,                // Vector x.
            1                   // Stride within X. For example, if incX is 7, every 7th element is multiplied by alpha.
        )
        
        return va
    }
    
    /**
     alpha  -> scalar
     A      -> vector
     beta   -> scalar
     B      -> vector
     
     return -> (alpha * A) + (beta * B)
     */
    public static func sumVectors(alpha: Float, A: [Float], beta: Float, B: [Float]) -> [Float] {
        var vb: [Float] = B
        
        // Computes the sum of two vectors, scaling each one separately (single-precision).
        catlas_saxpby(
            Int32(A.count),     // Number of elements in the vector.
            alpha,              // Scaling factor for X.
            A,                  // Input vector X.
            1,                  // Stride within X. For example, if incX is 7, every 7th element is used.
            beta,               // Scaling factor for Y.
            &vb,                // Input vector Y.
            1                   // Stride within Y. For example, if incY is 7, every 7th element is used.
        )
        
        return vb
    }
    
    /**
     transposeM -> boolean (Transpose M)
     alpha      -> scalar
     M          -> matrix
     A          -> vector
     
     return     -> (alpha * M * A) or (alpha * M(T) * a)
     */
    public static func multiplyMatrixByVector(transposeM: Bool, alpha: Float, M: [Float], MRows: Int, MCols: Int, A: [Float]) -> [Float] {
        var out: [Float] = Array(repeating: 0.0, count: transposeM ? MCols : MRows)
        
        
        // Multiplies a single-precision matrix by a vector.
        cblas_sgemv(
            CblasRowMajor,                              // Specifies row-major (C) or column-major (Fortran) data ordering.
            transposeM ? CblasTrans : CblasNoTrans,     // Specifies whether to transpose matrix A.
            Int32(MRows),                               // Number of rows in matrix A.
            Int32(MCols),                               // Number of columns in matrix A.
            alpha,                                      // Scaling factor for the product of matrix A and vector X.
            M,                                          // Matrix A.
            Int32(MCols),                               // The size of the first dimension of matrix A. For a matrix A[M][N] that uses column-major ordering, the value is the number of rows M. For a matrix that uses row-major ordering, the value is the number of columns N.
            A,                                          // Vector X.
            1,                                          // Stride within X. For example, if incX is 7, every seventh element is used.
            1,                                          // Scaling factor for vector Y.
            &out,                                       // Vector Y
            1                                           // Stride within Y. For example, if incY is 7, every seventh element is used.
        )
        
        return out
    }
    
    /**
     A  -> vector
     
     return ||A||_2
     */
    public static func vectorL2Norm(_ A: [Float]) -> Float {
        // Computes the L2 norm (Euclidian length) of a vector (single precision).
        return cblas_snrm2(
            Int32(A.count),     // Length of vector X.
            A,                  // Vector X.
            1                   // Stride within X. For example, if incX is 7, every 7th element is used.
        )
    }
    
    
    public static func multiplyMatrixByVector(
        matrix: [Float],
        rows: Int,
        columns: Int,
        transposeMatrix: Bool = false,
        vector: [Float]
    ) -> [Float] {
        let matrixRowCount = Int32(rows)
        let matrixColumnCount = Int32(columns)
        var result: [Float] = Array(repeating: 0, count: vector.count)
        cblas_sgemv(
            CblasRowMajor,
            transposeMatrix ? CblasTrans : CblasNoTrans,
            matrixRowCount,
            matrixColumnCount,
            1,
            matrix,
            matrixColumnCount,
            vector,
            1,
            1,
            &result,
            1
        )
        return result
    }
    
    public static func multiplyVectorByItsTranspose(_ vector: [Float]) -> Float {
        var result: [Float] = [0]
        cblas_sgemm(
            CblasRowMajor,
            CblasTrans,
            CblasNoTrans,
            1,
            1,
            Int32(vector.count),
            1,
            vector,
            1,
            vector,
            1,
            1,
            &result,
            1
        )
        
        return result[0]
    }
    
    public static func euclideanNorm(of vector: [Float]) -> Float {
        let result = cblas_snrm2(
            Int32(vector.count),
            vector,
            1
        )
        
        return result
    }
    
    public static func sumVectors(
        _ vector1: [Float],
        alpha: Float = 1,
        _ vector2: [Float],
        beta: Float = 1
    ) -> [Float] {
        let vectorsElementCount = Int32(vector1.count)
        var result = vector2
        catlas_saxpby(
            vectorsElementCount,
            alpha,
            vector1,
            1,
            beta,
            &result,
            1
        )
        
        return result
    }
}
