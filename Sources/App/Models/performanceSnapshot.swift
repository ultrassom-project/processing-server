import Vapor

public struct PerformanceSnapshot: Content {
    let date: Date
    let memory: Float
    let cpu: Float
}
