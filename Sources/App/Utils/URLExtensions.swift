import Foundation
import Vapor

extension URL {
    static func fromFilesFolder(name: String, ext: String) -> URL {
        let workingDirectory = DirectoryConfiguration.detect().workingDirectory
        
        return URL(fileURLWithPath: workingDirectory, isDirectory: true)
            .appendingPathComponent("Sources", isDirectory: true)
            .appendingPathComponent("App", isDirectory: true)
            .appendingPathComponent("Files", isDirectory: true)
            .appendingPathComponent(name, isDirectory: false)
            .appendingPathExtension(ext)
    }
}
