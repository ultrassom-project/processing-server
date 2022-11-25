import Vapor

public struct EnqueueReconstructonResponse: Content {
    let id: Int
}

public func enqueueReconstruction(req: Request) async throws -> EnqueueReconstructonResponse {
    var input = try req.content.decode(ReconstructionInput.self)
    
    let inputId = ReconstructionManager.instance.getTotalReconstructions()
    input.id = inputId
    ReconstructionManager.instance.enqueueInput(input)
    
    return EnqueueReconstructonResponse(id: inputId)
}

public func getReconstructionsReport(req: Request) async throws -> [ReconstructionOutput] {
    return ReconstructionManager.instance.getReport()
}
