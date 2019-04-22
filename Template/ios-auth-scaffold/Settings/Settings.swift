//
//  Settings.swift
//  ios-auth-scaffold
//
//  Created by Samuel Marks on 18/2/18.
//  Copyright © 2018 Samuel Marks. All rights reserved.
//

import Foundation
import os.log

class Settings: Loopable {
    public static var hostname: String? {
        didSet {
            Settings.saveCache()
        }
    }

    public static var access_token: String? {
        didSet {
            Settings.saveCache()
        }
    }

    static func saveCache() {
        let defaults = UserDefaults.standard
        defaults.set(Settings.hostname, forKey: "hostname")
        defaults.set(Settings.access_token, forKey: "access_token")
    }

    static func loadCache() {
        let defaults = UserDefaults.standard
        Settings.hostname = defaults.string(forKey: "hostname")
        Settings.access_token = defaults.string(forKey: "access_token")
    }

    //MARK: Initialization
    init?(hostname: String?) {
        // The hostname must not be empty
        guard hostname != nil && !(hostname?.isEmpty)! else {
            return nil
        }

        // Initialize stored properties.
        if (Settings.hostname != hostname) {
            Settings.hostname = hostname
        }
    }
}
