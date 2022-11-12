import Vapor
import Queues
import QueuesRedisDriver
import Cocoa

public func configure(_ app: Application) throws {
    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .all,
        allowedMethods: [.GET, .POST, .PUT, .OPTIONS, .DELETE, .PATCH],
        allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent, .accessControlAllowOrigin]
    )
    let cors = CORSMiddleware(configuration: corsConfiguration)
    app.middleware.use(cors, at: .beginning)

    try routes(app)
    
    PerformanceManager.instance.configure()
    
    try app.queues.use(.redis(url: "redis://127.0.0.1:6379"))
    app.queues.schedule(CreatePerformanceManagerSnapshot()).everySecond()
    app.queues.schedule(RunReconstructionManagerHandler()).everySecond()
    try app.queues.startScheduledJobs()
    
//    ReconstructionManager.instance.enqueueInput(
//        generateReconstructionInputFromFile(
//            fileName: "signal_30x30_1",
//            ext: "csv",
//            dimension: ._30x30,
//            algorithm: .CGNE,
//            signalGain: 1
//        )
//    )
//
//    ReconstructionManager.instance.enqueueInput(
//        generateReconstructionInputFromFile(
//            fileName: "signal_30x30_1",
//            ext: "csv",
//            dimension: ._30x30,
//            algorithm: .CGNR,
//            signalGain: 1
//        )
//    )
//
//    ReconstructionManager.instance.enqueueInput(
//        generateReconstructionInputFromFile(
//            fileName: "signal_30x30_2",
//            ext: "csv",
//            dimension: ._30x30,
//            algorithm: .CGNE,
//            signalGain: 1
//        )
//    )
//
//    ReconstructionManager.instance.enqueueInput(
//        generateReconstructionInputFromFile(
//            fileName: "signal_30x30_2",
//            ext: "csv",
//            dimension: ._30x30,
//            algorithm: .CGNR,
//            signalGain: 1
//        )
//    )
//
//    ReconstructionManager.instance.enqueueInput(
//        generateReconstructionInputFromFile(
//            fileName: "signal_30x30_3",
//            ext: "csv",
//            dimension: ._30x30,
//            algorithm: .CGNE,
//            signalGain: 1
//        )
//    )
//
//    ReconstructionManager.instance.enqueueInput(
//        generateReconstructionInputFromFile(
//            fileName: "signal_30x30_3",
//            ext: "csv",
//            dimension: ._30x30,
//            algorithm: .CGNR,
//            signalGain: 1
//        )
//    )
//
//    ReconstructionManager.instance.enqueueInput(
//        generateReconstructionInputFromFile(
//            fileName: "signal_60x60_1",
//            ext: "csv",
//            dimension: ._60x60,
//            algorithm: .CGNE,
//            signalGain: 1
//        )
//    )
//
//    ReconstructionManager.instance.enqueueInput(
//        generateReconstructionInputFromFile(
//            fileName: "signal_60x60_1",
//            ext: "csv",
//            dimension: ._60x60,
//            algorithm: .CGNR,
//            signalGain: 1
//        )
//    )
//
//    ReconstructionManager.instance.enqueueInput(
//        generateReconstructionInputFromFile(
//            fileName: "signal_60x60_2",
//            ext: "csv",
//            dimension: ._60x60,
//            algorithm: .CGNE,
//            signalGain: 1
//        )
//    )
//
//    ReconstructionManager.instance.enqueueInput(
//        generateReconstructionInputFromFile(
//            fileName: "signal_60x60_2",
//            ext: "csv",
//            dimension: ._60x60,
//            algorithm: .CGNR,
//            signalGain: 1
//        )
//    )
//
//
//    ReconstructionManager.instance.enqueueInput(
//        generateReconstructionInputFromFile(
//            fileName: "signal_60x60_3",
//            ext: "csv",
//            dimension: ._60x60,
//            algorithm: .CGNE,
//            signalGain: 1
//        )
//    )
    
//    ReconstructionManager.instance.enqueueInput(
//        generateReconstructionInputFromFile(
//            fileName: "signal_60x60_3",
//            ext: "csv",
//            dimension: ._60x60,
//            algorithm: .CGNR,
//            signalGain: 1
//        )
//    )
//
//    ReconstructionManager.instance.enqueueInput(
//        generateReconstructionInputFromFile(
//            fileName: "signal_60x60_3",
//            ext: "csv",
//            dimension: ._60x60,
//            algorithm: .CGNR,
//            signalGain: 1
//        )
//    )
//
//    ReconstructionManager.instance.enqueueInput(
//        generateReconstructionInputFromFile(
//            fileName: "signal_60x60_3",
//            ext: "csv",
//            dimension: ._60x60,
//            algorithm: .CGNR,
//            signalGain: 1
//        )
//    )
//
//    ReconstructionManager.instance.enqueueInput(
//        generateReconstructionInputFromFile(
//            fileName: "signal_60x60_3",
//            ext: "csv",
//            dimension: ._60x60,
//            algorithm: .CGNR,
//            signalGain: 1
//        )
//    )
//
//    ReconstructionManager.instance.enqueueInput(
//        generateReconstructionInputFromFile(
//            fileName: "signal_60x60_3",
//            ext: "csv",
//            dimension: ._60x60,
//            algorithm: .CGNR,
//            signalGain: 1
//        )
//    )
}
