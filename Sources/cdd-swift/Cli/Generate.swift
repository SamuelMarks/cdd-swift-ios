//
//  Generate.swift
//  Basic
//
//  Created by Rob Saunders on 7/8/19.
//

import Foundation
import SwiftCLI

let TEMPLATE_PATH = "/.cdd/swift"

class GenerateCommand: Command {
	let name = "generate"
	let shortDescription = "Generates a new CDD project."
	let projectName = SwiftCLI.Parameter()
	let projectPath = Key<String>("-p", "--project-path", description: "Manually specify a path to output the project")
    let output = Flag("-out", "--output-file", description: "Output logging to file", defaultValue:false)
    
	func execute() throws {
		let templatePath = NSHomeDirectory() + TEMPLATE_PATH

        if output.value {
            log.enableFileOutput()
        }
        
		guard fileExists(file: templatePath) else {
			log.errorMessage("Template path does not exist: \(templatePath)")
			return
		}

		let targetDir:String = {
			if let projectPath = projectPath.value {
				return projectPath
			} else {
				return "./\(projectName.value)"
			}
		}()

		copyDirectory(from: templatePath, to: targetDir)
		log.infoMessage("Project template successfully generated at \(targetDir)")
	}
}

