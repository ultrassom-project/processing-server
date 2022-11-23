import Vapor

public struct PerformanceSnapshot: Content {
    let date: Date
    let memory: Float
    let cpu: Float
    let reconstructionsInProgress: Int
    let reconstructionsInQueue: Int
    let finishedReconstructions: Int
}
