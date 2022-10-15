import Vapor

public struct ReconstructionOutput: Content {
    let input: ReconstructionInput
    let outputVector: [Float]
    let iterations: Int
    let startTime: Date
    let endTime: Date
}
