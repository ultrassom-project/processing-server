import Foundation

public class CGNE: ReconstructionAlgorithm {
    public init() {
        super.init(modelUrl: URL.fromFilesFolder(name: "cgnr", ext: "csv"))
    }
    
    public override func run(reconstructionInput: ReconstructionInput, errorConvergence: Float) -> ReconstructionOutput? {
        return ReconstructionOutput(input: reconstructionInput, outputImageArray: [], iterations: 10, startTime: Date(), endTime: Date())
    }
}
