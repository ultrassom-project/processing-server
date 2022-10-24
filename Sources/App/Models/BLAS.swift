import Foundation
import Accelerate

public class BLAS {
    /**
     v1Scale    -> scalar
     v1         -> vector
     v2Scale    -> scalar
     v2         -> vector
     
     return -> (v1Scale * v1) + (v2Scale * v2)
     */
    public static func sumVectors(v1Scale: Float = 1, v1: [Float], v2Scale: Float = 1, v2: [Float]) -> [Float] {
        var vb: [Float] = v2
        
        // Computes the sum of two vectors, scaling each one separately (single-precision).
        catlas_saxpby(
            Int32(v1.count),    // Number of elements in the vector.
            v1Scale,            // Scaling factor for X.
            v1,                 // Input vector X.
            1,                  // Stride within X. For example, if incX is 7, every 7th element is used.
            v2Scale,            // Scaling factor for Y.
            &vb,                // Input vector Y.
            1                   // Stride within Y. For example, if incY is 7, every 7th element is used.
        )
        
        return vb
    }
    
    /**
     transposeM -> boolean
     MScale     -> scalar
     M          -> matrix
     MRows      -> integer
     MCols      -> integer
     v          -> vector
     
     return     -> (MScale * M * v) or (MScale * M(T) * v)
     */
    public static func multiplyMatrixByVector(transposeM: Bool = false, MScale: Float = 1, M: [Float], MRows: Int, MCols: Int, v: [Float]) -> [Float] {
        var out: [Float] = Array(repeating: 0.0, count: transposeM ? MCols : MRows)
        
        // Multiplies a single-precision matrix by a vector.
        cblas_sgemv(
            CblasRowMajor,                              // Specifies row-major (C) or column-major (Fortran) data ordering.
            transposeM ? CblasTrans : CblasNoTrans,     // Specifies whether to transpose matrix A.
            Int32(MRows),                               // Number of rows in matrix A.
            Int32(MCols),                               // Number of columns in matrix A.
            MScale,                                     // Scaling factor for the product of matrix A and vector X.
            M,                                          // Matrix A.
            Int32(MCols),                               // The size of the first dimension of matrix A. For a matrix A[M][N] that uses column-major ordering, the value is the number of rows M. For a matrix that uses row-major ordering, the value is the number of columns N.
            v,                                          // Vector X.
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
    public static func vectorL2Norm(_ v: [Float]) -> Float {
        // Computes the L2 norm (Euclidian length) of a vector (single precision).
        return cblas_snrm2(
            Int32(v.count),     // Length of vector X.
            v,                  // Vector X.
            1                   // Stride within X. For example, if incX is 7, every 7th element is used.
        )
    }
    
    /**
     v  -> vector
     
     return ?
     */
    public static func multiplyVectorByItsTranspose(_ v: [Float]) -> Float {
        var out: [Float] = [0]
        
        // Multiplies two matrices (single-precision).
        cblas_sgemm(
            CblasRowMajor,      // Specifies row-major (C) or column-major (Fortran) data ordering.
            CblasTrans,         // Specifies whether to transpose matrix A.
            CblasNoTrans,       // Specifies whether to transpose matrix B.
            1,                  // Number of rows in matrices A and C.
            1,                  // Number of columns in matrices B and C.
            Int32(v.count),     // Number of columns in matrix A; number of rows in matrix B.
            1,                  // Scaling factor for the product of matrices A and B.
            v,                  // Matrix A.
            1,                  // The size of the first dimension of matrix A; if you are passing a matrix A[m][n], the value should be m.
            v,                  // Matrix B.
            1,                  // The size of the first dimension of matrix B; if you are passing a matrix B[m][n], the value should be m.
            1,                  // Scaling factor for matrix C.
            &out,               // Matrix C.
            1                   // The size of the first dimension of matrix C; if you are passing a matrix C[m][n], the value should be m.
        )
        
        return out[0]
    }
}
