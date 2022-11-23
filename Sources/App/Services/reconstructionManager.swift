import Vapor

public class ReconstructionManager {
    public static let instance = ReconstructionManager()
    private init() {}
    
    private let logger = Logger(label: "ReconstructionManager")
    private let reconstructionService = ReconstructionService()
    private var inputQueue = FIFOQueue<ReconstructionInput>()
    private var outputList = [ReconstructionOutput]()
    
    public func enqueueInput(_ item: ReconstructionInput) {
        Task(priority: .background) {
            inputQueue.enqueue(item)
        }
    }
    
    public func getReport() -> [ReconstructionOutput] {
        return self.outputList
    }
    
    public func getReconstructionsInProgress() -> Int {
        return self.reconstructionService.getReconstructionsInProgress()
    }
    
    public func getReconstructionsInQueue() -> Int {
        return self.inputQueue.size()
    }
    
    public func getFinishedReconstructions() -> Int {
        return self.outputList.count
    }
    
    public func handle() {
        Task(priority: .medium) {
            guard reconstructionService.canStartNewReconstruction() == true else {
                logger.debug("Cannot start new reconstruction: Reconstruction service busy")
                return
            }
            
            guard let input = inputQueue.dequeue() else {
                logger.debug("Cannot start new reconstruction: Input queue empty")
                return
            }
            
            logger.info("Reconstruction \(input.userId) \(input.dimension) started")
            
            guard let reconstructionOutput = reconstructionService.reconstruct(input) else {
                logger.error("Reconstruction \(input.userId) \(input.dimension) failed")
                return
            }
            
            logger.info("Reconstruction \(input.userId) \(input.dimension) finished with success")
            outputList.append(reconstructionOutput)
        }
    }
}
