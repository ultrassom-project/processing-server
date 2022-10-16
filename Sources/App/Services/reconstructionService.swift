import Foundation

public class ReconstructionService {
    private let cgnr = CGNR()
    private let cgne = CGNE()
    private var reconstructionsInProgress = 0
    private let errorConvergence: Float = 1e-4
    
    public init() {}
    
    public func reconstruct(_ input: ReconstructionInput) -> ReconstructionOutput? {
        reconstructionsInProgress += 1;
        
        defer {
            reconstructionsInProgress -= 1;
        }
            
        switch (input.algorithm) {
            case .CGNE:
                cgnr.unloadModel()
                cgne.loadModel()
                return cgne.run(reconstructionInput: input, errorConvergence: errorConvergence)
            
            case .CGNR:
                cgne.unloadModel()
                cgnr.loadModel()
                return cgnr.run(reconstructionInput: input, errorConvergence: errorConvergence)
        }
    }
    
    public func canStartNewReconstruction() -> Bool {
        // TODO: ask performance manager for current status (maybe)
        return reconstructionsInProgress <= 1
    }
}
