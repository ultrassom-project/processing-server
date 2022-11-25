import Vapor

public enum ReconstructionAlgorithmType: String, Codable {
    case CGNR
    case CGNE
}

public enum ReconstructionDimension: Int, Codable {
    case _30x30 = 30
    case _60x60 = 60
    
    func modelURL() -> URL {
        switch self {
            case ._30x30:
                return URL.fromFilesFolder(name: "model_30x30", ext: "csv")
            case ._60x60:
                return URL.fromFilesFolder(name: "model_60x60", ext: "csv")
        }
    }
    
    func binFileModelURL() -> URL {
        switch self {
            case ._30x30:
                return URL.fromFilesFolder(name: "model_30x30", ext: "binExit")
            case ._60x60:
                return URL.fromFilesFolder(name: "model_60x60", ext: "binExit")
        }
    }
    
    func name() -> String {
        switch self {
            case ._30x30:
                return "30x30"
            case ._60x60:
                return "60x60"
        }
    }
}

public struct ReconstructionInput: Content {
    var id: Int?
    let userId: String
    let algorithm: ReconstructionAlgorithmType
    let dimension: ReconstructionDimension
    let signalVector: [Float]
}
