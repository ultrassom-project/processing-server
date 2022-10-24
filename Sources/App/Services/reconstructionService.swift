import Foundation
import Vapor

public class ReconstructionService {
    public let logger = Logger(label: "ReconstructionAlgorithm")
    
    private var modelRows: Int = 0
    private var modelCols: Int = 0
    private var model: [Float]?
    private var modelDimension: ReconstructionDimension?
    
    private let cgnr: ReconstructionAlgorithm = CGNR()
    private let cgne: ReconstructionAlgorithm = CGNE()
    private let errorConvergence: Float = 1e-4
    
    private var reconstructionsInProgress: Int = 0
    
    public init() {}
    
    private func loadModel(dimension: ReconstructionDimension) {
        guard modelDimension != dimension else {
            return
        }

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
        self.model = []
        
        var rows = 0
        var cols = 0
        while (bytesRead > 0) {
            let lineAsString: String = String.init(cString: lineByteArrayPointer!)
            let lineAsFloatArray: [Float] = lineAsString.components(separatedBy: ",").map { ($0 as NSString).floatValue }
            model?.append(contentsOf: lineAsFloatArray)
            bytesRead = getline(&lineByteArrayPointer, &lineCap, filePointer)
            
            rows += 1
            cols = lineAsFloatArray.count
        }
        
        self.modelRows = rows
        self.modelCols = cols
        self.modelDimension = dimension
        
        let duration = Date().timeIntervalSince(startDate)
        logger.info("Model \(dimension) loaded in \(duration) seconds")
    }
    
    public func reconstruct(_ input: ReconstructionInput) -> ReconstructionOutput? {
        reconstructionsInProgress += 1
        
        defer {
            reconstructionsInProgress -= 1
        }
        
        loadModel(dimension: input.dimension)
            
        switch (input.algorithm) {
            case .CGNE:
                return cgne.run(model: &model, modelRows: modelRows, modelCols: modelCols, reconstructionInput: input, errorConvergence: errorConvergence)

            case .CGNR:
                return cgnr.run(model: &model, modelRows: modelRows, modelCols: modelCols, reconstructionInput: input, errorConvergence: errorConvergence)
        }
    }
    
    public func canStartNewReconstruction() -> Bool {
        // TODO: ask performance manager for current status (maybe)
        return reconstructionsInProgress <= 1
    }
}
