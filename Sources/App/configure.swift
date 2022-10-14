import Vapor
import Queues
import QueuesRedisDriver

public func configure(_ app: Application) throws {
    PerformanceManager.instance.setup()

    try routes(app)
    
    try app.queues.use(.redis(url: "redis://127.0.0.1:6379"))
    
    app.queues.schedule(CreatePerformanceManagerSnapshot()).everySecond()
    app.queues.schedule(RunReconstructionManagerHandler()).everySecond()
    
    try app.queues.startInProcessJobs()
    try app.queues.startScheduledJobs()
}
