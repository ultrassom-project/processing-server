import Foundation

public class ReconstructionService {
    private let cgnr: CGNR
    private let cgne: CGNE
    private var reconstructionsInProgress = 0
    private let errorConvergence: Float = 0.0001
    
    init() {
        let filesFolderUrl = URL(fileURLWithPath: "\(#file)", isDirectory: false)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("Files", isDirectory: true)
        
        self.cgnr = CGNR(modelUrl: filesFolderUrl.appendingPathComponent("cgnr",isDirectory: false).appendingPathExtension("csv"))
        self.cgne = CGNE(modelUrl: filesFolderUrl.appendingPathComponent("cgne",isDirectory: false).appendingPathExtension("csv"))
    }
    
    public func reconstruct(_ input: ReconstructionInput) -> ReconstructionOutput? {
        reconstructionsInProgress += 1;
            
        switch (input.algorithm) {
            case Algorithm.CGNE:
                cgnr.unloadModel()
                cgne.loadModel()
                let output = cgne.run(reconstructionInput: input, errorConvergence: errorConvergence)
                reconstructionsInProgress -= 1;
                return output
            
            case Algorithm.CGNR:
                cgne.unloadModel()
                cgnr.loadModel()
                let output = cgnr.run(reconstructionInput: input, errorConvergence: errorConvergence)
                reconstructionsInProgress -= 1;
                return output
        }
    }
    
    public func canStartNewReconstruction() -> Bool {
        return reconstructionsInProgress <= 1
    }
}
