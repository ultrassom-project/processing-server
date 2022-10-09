import Foundation
import Vapor


public func enqueueReconstruction(req: Request) async throws -> HTTPStatus {
    let reconstruction = try req.content.decode(ReconstructionInput.self)
    ReconstructionManager.instance.enqueue(reconstruction)
    return HTTPStatus.created
}

public func getReconstructionsReport(req: Request) async throws -> [ReconstructionOutput] {
    return ReconstructionManager.instance.getReport()
}
