import Vapor

func routes(_ app: Application) throws {
    let reconstruction = app.grouped("reconstructions")
    reconstruction.post(use: enqueueReconstruction)
    reconstruction.get("report", use: getReconstructionsReport)
    
    let performance = app.grouped("performance")
    performance.get(use: getPerformanceReport)
}
