import Queues

public struct CreatePerformanceManagerSnapshot: AsyncScheduledJob {
    private static let runEvery: Int = 5
    private static var i: Int = 0
    
    public func run(context: Queues.QueueContext) async throws {
        Self.i += 1
        
        if Self.i % Self.runEvery == 0 {
            PerformanceManager.instance.createSnapshot()
        }
    }
}
