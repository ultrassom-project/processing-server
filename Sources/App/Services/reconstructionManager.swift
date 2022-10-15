import Vapor

public class ReconstructionManager {
    public static let instance = ReconstructionManager()
    private init() {}
    
    private let logger = Logger(label: "ReconstructionManager")
    private let reconstructionService = ReconstructionService()
    private var inputQueue = FIFOQueue<ReconstructionInput>()
    private var outputList = [ReconstructionOutput]()
    
    public func enqueueInput(_ item: ReconstructionInput) {
        inputQueue.enqueue(item)
    }
    
    public func getReport() -> [ReconstructionOutput] {
        return self.outputList
    }
    
    public func handle() {
        guard reconstructionService.canStartNewReconstruction() == true else {
            logger.debug("Cannot start new reconstruction: Reconstruction service busy")
            return
        }
        
        guard let input = inputQueue.dequeue() else {
            logger.debug("Cannot start new reconstruction: Input queue empty")
            return
        }
        
        Task(priority: .background) {
            logger.info("Reconstruction started")
            
            guard let reconstructionOutput = reconstructionService.reconstruct(input) else {
                logger.error("Reconstruction failed")
                return
            }
            
            logger.info("Reconstruction finished with success")
            outputList.append(reconstructionOutput)
        }
    }
}
