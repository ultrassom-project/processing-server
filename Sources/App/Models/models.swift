import Foundation
import Vapor

public enum Algorithm: String, Codable {
    case CGNR
    case CGNE
}

public struct ReconstructionInput: Content {
    let userId: String
    let algorithm: Algorithm
    let signalGain: Float
    let signalVector: [Float]
}

public struct ReconstructionOutput: Content {
    let input: ReconstructionInput
    let outputVector: [Float]
    let iterations: Int
    let startTime: Date
    let endTime: Date
}

public struct PerformanceSnapshot: Content {
    let date: Date
    let memory: Float
    let cpu: Float
}

public struct GetPerformanceReportQuery: Content {
    let startDate: Date
    let endDate: Date
}
