import Vapor

public func enqueueReconstruction(req: Request) async throws -> HTTPStatus {
    let input = try req.content.decode(ReconstructionInput.self)
    ReconstructionManager.instance.enqueueInput(input)
    return HTTPStatus.created
}

public func getReconstructionsReport(req: Request) async throws -> [ReconstructionOutput] {
    return ReconstructionManager.instance.getReport()
}
