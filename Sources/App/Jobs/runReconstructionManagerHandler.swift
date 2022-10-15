import Queues

public struct RunReconstructionManagerHandler: AsyncScheduledJob {
    public func run(context: Queues.QueueContext) async throws {
        ReconstructionManager.instance.handle()
    }
}
