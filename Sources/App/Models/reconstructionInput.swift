import Vapor

public enum ReconstructionAlgorithmType: String, Codable {
    case CGNR
    case CGNE
}

public struct ReconstructionInput: Content {
    let userId: String
    let algorithm: ReconstructionAlgorithmType
    let signalGain: Float
    let signalVector: [Float]
}
