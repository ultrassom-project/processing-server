import Foundation

public class ReconstructionManager {
    public static let instance = ReconstructionManager()
    private init() { }
    
    private var inputQueue = [ReconstructionInput]()
    private var outputQueue = [ReconstructionOutput]()
    
    public func setup() { }
    
    public func enqueue(_ input: ReconstructionInput) {
        self.inputQueue.append(input)
    }
    
    public func getReport() -> [ReconstructionOutput] {
        return self.outputQueue
    }
}
