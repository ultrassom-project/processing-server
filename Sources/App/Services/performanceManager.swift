import Foundation

public class PerformanceManager {
    public static let instance = PerformanceManager()
    private init() { }
    
    private var snapshots = [PerformanceSnapshot]()
    private var lastCpuLoad: host_cpu_load_info?
    
    public func setup() {
        self.lastCpuLoad = hostCPULoadInfo()
        
        // TODO: create scheduled task that calls createSnapshot() every 5 seconds
        self.createSnapshot()
    }
    
    public func createSnapshot() {
        let snapshot = PerformanceSnapshot(date: Date(), memory: self.getMemoryUsage(), cpu: self.getCpuUsage())
        self.snapshots.append(snapshot)
    }
    
    public func getReport(startDate: Date, endDate: Date) -> [PerformanceSnapshot] {
        return snapshots.filter { $0.date >= startDate && $0.date <= endDate }
    }
    
    private func getMemoryUsage() -> Float {
        var used_megabytes: Float = 0
            
        let total_bytes = Float(ProcessInfo.processInfo.physicalMemory)
        let total_megabytes = total_bytes / 1024.0 / 1024.0
        
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
        
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(
                    mach_task_self_,
                    task_flavor_t(MACH_TASK_BASIC_INFO),
                    $0,
                    &count
                )
            }
        }
        
        if kerr == KERN_SUCCESS {
            let used_bytes: Float = Float(info.resident_size)
            used_megabytes = used_bytes / 1024.0 / 1024.0
        }
        
        return used_megabytes / total_megabytes * 100
    }
    
    private func getCpuUsage() -> Float {
        guard let load = self.hostCPULoadInfo(), let lastLoad = self.lastCpuLoad else {
            return 0
        }

        let usrDiff = Float(load.cpu_ticks.0 - lastLoad.cpu_ticks.0);
        let systDiff = Float(load.cpu_ticks.1 - lastLoad.cpu_ticks.1);
        let idleDiff = Float(load.cpu_ticks.2 - lastLoad.cpu_ticks.2);
        let niceDiff = Float(load.cpu_ticks.3 - lastLoad.cpu_ticks.3);

        let totalTicks = usrDiff + systDiff + idleDiff + niceDiff
        let sys = systDiff / totalTicks * 100.0
        let usr = usrDiff / totalTicks * 100.0
        let idle = idleDiff / totalTicks * 100.0
        let nice = niceDiff / totalTicks * 100.0
        self.lastCpuLoad = load

        return 100 - idle;
    }
    
    private func hostCPULoadInfo() -> host_cpu_load_info? {
        let HOST_CPU_LOAD_INFO_COUNT = MemoryLayout<host_cpu_load_info>.stride/MemoryLayout<integer_t>.stride
        var size = mach_msg_type_number_t(HOST_CPU_LOAD_INFO_COUNT)
        var cpuLoadInfo = host_cpu_load_info()

        let result = withUnsafeMutablePointer(to: &cpuLoadInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: HOST_CPU_LOAD_INFO_COUNT) {
                host_statistics(mach_host_self(), HOST_CPU_LOAD_INFO, $0, &size)
            }
        }
        if result != KERN_SUCCESS{
            print("Error  - \(#file): \(#function) - kern_result_t = \(result)")
            return nil
        }
        return cpuLoadInfo
    }
}
