
import Foundation
import Willow

class FileWriter: LogWriter {
    private let path: String
    private let modifier = ColorModifier()
    
    init(filePath: String) {
        path = filePath
        try? "".write(toFile: path, atomically: true, encoding: .utf8)
    }
    
    func writeMessage(_ message: String, logLevel: LogLevel) {
        let mess = modifier.modifyMessage(message, with: logLevel)
        let text = try? String(contentsOf: URL(fileURLWithPath: path))
        try? ((text ?? "") + "\n" + mess).write(toFile: path, atomically: true, encoding: .utf8)
    }
    
    func writeMessage(_ message: LogMessage, logLevel: LogLevel) {
        
    }
    

   
}
