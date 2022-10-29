import Foundation
import Vapor

public class ReconstructionService {
    public let logger = Logger(label: "ReconstructionAlgorithm")
    
    private var model30x30: [Float]?
    private var model30x30Rows: Int = 0
    private var model30x30Cols: Int = 0
    private var model30x30Loaded: Bool = false
    
    private var model60x60: [Float]?
    private var model60x60Rows: Int = 0
    private var model60x60Cols: Int = 0
    private var model60x60Loaded: Bool = false
    
    private let cgnr: ReconstructionAlgorithm = CGNR()
    private let cgne: ReconstructionAlgorithm = CGNE()
    private let errorConvergence: Float = 1e-4
    
    private var reconstructionsInProgress: Int = 0
    
    public init() {
        Task(priority: .high) {
            loadModel(dimension: ReconstructionDimension._30x30, model: &model30x30, rows: &model30x30Rows, cols: &model30x30Cols)
            model30x30Loaded = true
        }
        
        Task(priority: .high) {
            loadModel(dimension: ReconstructionDimension._60x60, model: &model60x60, rows: &model60x60Rows, cols: &model60x60Cols)
            model60x60Loaded = true
        }
    }
    
    private func loadModel(dimension: ReconstructionDimension, model: inout [Float]?, rows: inout Int, cols: inout Int) {
        logger.info("Model \(dimension.name()) being loaded")
        guard FileManager.default.fileExists(atPath: dimension.modelURL().path) else {
            logger.error("Model file \(dimension.modelURL().absoluteString) is missing")
            return
        }
        
        guard let filePointer: UnsafeMutablePointer<FILE> = fopen(dimension.modelURL().path, "r") else {
            logger.error("Could not open model file at \(dimension.modelURL().absoluteString)")
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
        model = []
        
        var modelRows = 0
        var modelCols = 0
        while (bytesRead > 0) {
            let lineAsString: String = String.init(cString: lineByteArrayPointer!)
            let lineAsFloatArray: [Float] = lineAsString.components(separatedBy: ",").map { ($0 as NSString).floatValue }
            model?.append(contentsOf: lineAsFloatArray)
            bytesRead = getline(&lineByteArrayPointer, &lineCap, filePointer)
            
            modelRows += 1
            modelCols = lineAsFloatArray.count
        }
        
        rows = modelRows
        cols = modelCols
        
        let duration = Date().timeIntervalSince(startDate)
        logger.info("Model \(dimension.name()) loaded in \(duration) seconds")
    }
    
    public func reconstruct(_ input: ReconstructionInput) -> ReconstructionOutput? {
        reconstructionsInProgress += 1
        
        defer {
            reconstructionsInProgress -= 1
        }
        
            
        switch (input.algorithm) {
            case .CGNE:
                if input.dimension == ._30x30 {
                    return cgne.run(
                        model: &model30x30,
                        modelRows: model30x30Rows,
                        modelCols: model30x30Cols,
                        reconstructionInput: input,
                        errorConvergence: errorConvergence
                    )
                } else {
                    return cgne.run(
                        model: &model60x60,
                        modelRows: model60x60Rows,
                        modelCols: model60x60Cols,
                        reconstructionInput: input,
                        errorConvergence: errorConvergence
                    )
                }
            case .CGNR:
                if input.dimension == ._30x30 {
                    return cgnr.run(
                        model: &model30x30,
                        modelRows: model30x30Rows,
                        modelCols: model30x30Cols,
                        reconstructionInput: input,
                        errorConvergence: errorConvergence
                    )
                } else {
                    return cgnr.run(
                        model: &model60x60,
                        modelRows: model60x60Rows,
                        modelCols: model60x60Cols,
                        reconstructionInput: input,
                        errorConvergence: errorConvergence
                    )
                }
                
        }
    }
    
    public func canStartNewReconstruction() -> Bool {
        if model60x60Loaded == false || model30x30Loaded == false {
            return false
        }
        
        return reconstructionsInProgress < 10
    }
}
