import Queues

public struct RunReconstructionManagerHandler: AsyncScheduledJob {
    
    public func run(context: Queues.QueueContext) async throws {
        print("Running RunReconstructionManagerHandler scheduled job")
        ReconstructionManager.instance.handle()
    }
}
