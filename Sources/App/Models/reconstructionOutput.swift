import Vapor

public struct ReconstructionOutput: Content {
    let input: ReconstructionInput
    let outputImageArray: [[String]]
    let iterations: Int
    let startTime: Date
    let endTime: Date
}
