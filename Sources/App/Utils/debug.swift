import Foundation

public func loadSignalVectorFromFile(fileName: String, ext: String) -> [Float] {
    let url = URL.fromFilesFolder(name: fileName, ext: ext)

    guard FileManager.default.fileExists(atPath: url.path) else {
        return []
    }
    
    guard let filePointer: UnsafeMutablePointer<FILE> = fopen(url.path, "r") else {
        return []
    }
    
    var lineByteArrayPointer: UnsafeMutablePointer<CChar>? = nil
    
    defer {
        fclose(filePointer)
        lineByteArrayPointer?.deallocate()
    }
    
    var lineCap: Int = 0
    var bytesRead = getline(&lineByteArrayPointer, &lineCap, filePointer)
    
    var signalVector: [Float] = []
            
    while bytesRead > 0 {
        var lineAsString: String = String(cString: lineByteArrayPointer!)
        let lineAsFloat: Float = (lineAsString as NSString).floatValue
        signalVector.append(lineAsFloat)
        bytesRead = getline(&lineByteArrayPointer, &lineCap, filePointer)
    }
    
    return signalVector
}
