import Queues
import Vapor

public class ReconstructionManager {
    public static let instance = ReconstructionManager()
    private init() {}
    
    private let reconstructionService = ReconstructionService()
    private var inputQueue = [ReconstructionInput]()
    private var outputList = [ReconstructionOutput]()
    
    public func enqueueReconstructionInput(_ input: ReconstructionInput) {
        inputQueue.append(input)
    }
    
    private func dequeueReconstructionInput() -> ReconstructionInput? {
        guard (inputQueue.first != nil) else {
            return nil
        }
        
        return inputQueue.removeFirst()
    }
    
    public func getReport() -> [ReconstructionOutput] {
        return self.outputList
    }
    
    public func handle() {
        guard reconstructionService.canStartNewReconstruction() == true else {
            print("Cannot start new reconstruction")
            return
        }
        
        guard let input = dequeueReconstructionInput() else {
            print("Input queue is empty")
            return
        }
        
        Task(priority: .background) {
            guard let reconstructionOutput = reconstructionService.reconstruct(input) else {
                print("Failed reconstructing input")
                return
            }
            
            outputList.append(reconstructionOutput)
        }
    }
}
