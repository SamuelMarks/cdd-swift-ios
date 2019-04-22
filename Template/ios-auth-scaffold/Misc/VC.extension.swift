//
//  VC.extension.swift
//  ios-auth-scaffold
//
//  Created by Samuel Marks on 20/2/18.
//  Copyright © 2018 Samuel Marks. All rights reserved.
//

import UIKit

extension UIViewController {
    func mainErr(error: ErrorResponse) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                    title: error.error, message: error.error_message, preferredStyle: .alert
            )
            alert.addAction(
                    UIAlertAction(title: NSLocalizedString("OK", comment: "Error"), style: .`default`,
                            handler: { _ in NSLog(error.toString()) })
            )

            self.present(alert, animated: true, completion: nil)
        }
    }

    func redirectIfUnauthenticated() {
        if Settings.access_token == nil {
            let storyboard = UIStoryboard(name: "Auth", bundle: nil)
            if let vc = storyboard.instantiateInitialViewController() {
                if let nc = self.navigationController {
                    nc.pushViewController(vc, animated: true)
                } else {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = vc
                }
            }
        }
    }
}
