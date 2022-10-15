import Vapor

public func getPerformanceReport(req: Request) async throws -> [PerformanceSnapshot] {
    let query = try req.query.decode(GetPerformanceReportQuery.self)
    return PerformanceManager.instance.getReport(startDate: query.startDate ?? Date.init(timeIntervalSince1970: 0), endDate: query.endDate ?? Date.now)
}
