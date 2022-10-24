import Foundation

public func generateReconstructionInputFromFile(
    fileName: String,
    ext: String,
    dimension: ReconstructionDimension,
    algorithm: ReconstructionAlgorithmType,
    signalGain: Float
) -> ReconstructionInput {
    return ReconstructionInput(
        userId: UUID().uuidString,
        algorithm: algorithm,
        dimension: dimension,
        signalGain: signalGain,
        signalVector: loadSignalVectorFromFile(fileName: fileName, ext: ext)
    )
}

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
        let lineAsString: String = String(cString: lineByteArrayPointer!)
        let lineAsFloat: Float = (lineAsString as NSString).floatValue
        signalVector.append(lineAsFloat)
        bytesRead = getline(&lineByteArrayPointer, &lineCap, filePointer)
    }
    
    return signalVector
}
