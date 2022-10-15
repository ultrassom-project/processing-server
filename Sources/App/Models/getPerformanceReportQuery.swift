import Vapor
import Foundation

public struct GetPerformanceReportQuery: Content {
    let startDate: Date?
    let endDate: Date?
}
