import Foundation
import Vapor
import Dispatch

public func getPerformanceReport(req: Request) async throws -> [PerformanceSnapshot] {
    let query = try req.query.decode(GetPerformanceReportQuery.self)
    return PerformanceManager.instance.getReport(startDate: query.startDate, endDate: query.endDate)
}
