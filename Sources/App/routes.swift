import Vapor

func routes(_ app: Application) throws {
    let reconstruction = app.grouped("reconstructions")
    reconstruction.on(.POST, "", body: .collect(maxSize: ByteCount(stringLiteral: "200MB")), use: enqueueReconstruction)
    reconstruction.on(.GET, "report", use: getReconstructionsReport)
    
    let performance = app.grouped("performance")
    performance.on(.GET, "", use: getPerformanceReport)
}
