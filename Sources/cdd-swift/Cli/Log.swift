import Willow
import Foundation

class ColorModifier: LogModifier {
    func modifyMessage(_ message: String, with logLevel: LogLevel) -> String {
        switch logLevel {
        case .error:
            return "[ERROR] \(message)".red
        case .info:
            return "[INFO] \(message)".yellow
        case .event:
            return "[OK] \(message)".green
        default:
            return "[OK] \(message)"
        }
    }
}

let writers = [ConsoleWriter(modifiers: [ColorModifier()])]
var log = Logger(logLevels: [.all], writers: writers)


extension Logger {
    func enableFileOutput() {
        guard let pwd = ProcessInfo.processInfo.environment["PWD"] else { return }
        
        let writers = [ConsoleWriter(modifiers: [ColorModifier()]), FileWriter(filePath: pwd + "/output.txt")] as [LogWriter]
        log = Logger(logLevels: [.all], writers: writers)
    }
}
