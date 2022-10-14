import Foundation

public class ReconstructionService {
    private let cgnr: CGNR = CGNR()
    private let cgne: CGNE = CGNE()
    private var reconstructionsInProgress = 0
    private let errorConvergence: Float = 0.0001
    
    public func reconstruct(_ input: ReconstructionInput) -> ReconstructionOutput? {
        reconstructionsInProgress += 1;
            
        switch (input.algorithm) {
            case Algorithm.CGNE:
                cgnr.unloadModel()
                cgne.loadModel(fileUrl: URL(fileURLWithPath: ""))
                let output = cgne.run(reconstructionInput: input, errorConvergence: errorConvergence)
                reconstructionsInProgress -= 1;
                return output
            
            case Algorithm.CGNR:
                cgne.unloadModel()
                cgnr.loadModel(fileUrl: URL(fileURLWithPath: ""))
                let output = cgnr.run(reconstructionInput: input, errorConvergence: errorConvergence)
                reconstructionsInProgress -= 1;
                return output
        }
    }
    
    public func canStartNewReconstruction() -> Bool {
        return reconstructionsInProgress <= 1
    }
}
