//
//  AuthVC.swift
//  ios-auth-scaffold
//
//  Created by Samuel Marks on 18/2/18.
//  Copyright © 2018 Samuel Marks. All rights reserved.
//

import UIKit

class AuthVC: UIViewController {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signInUp: UIButton!
    @IBOutlet weak var apiUrl: UILabel!
    @IBOutlet weak var version: UILabel!

    @IBAction func emailClicked(_ sender: UITextField) {
        password.isEnabled = true
    }

    @IBAction func passwordClicked(_ sender: UITextField) {
        signInUp.isEnabled = true
    }

    @IBAction func passwordActionTriggered(_ sender: UITextField) {
        signInUp.sendActions(for: .touchUpInside)
    }

    @IBAction func onSignInUpClicked(_ sender: UIButton) {
        let auth = Auth.init(email: email.text!, password: password.text!)
        AuthApi().register(auth: auth) { (error: ErrorResponse?, user: User?) in
            if let error = error {
                self.mainErr(error: error)
            } else if user != nil {
                self.redirectIfAuthenticated()
            }
        }
    }

    func initSettings() {
        Settings.loadCache()
        apiUrl.text = Settings.hostname
        ServerStatusApi(baseUrl: Settings.hostname).get { (error: ErrorResponse?, serverStatus: ServerStatus?) in
            if let error = error {
                self.mainErr(error: error)
            }
            if let serverStatus = serverStatus {
                DispatchQueue.main.async {
                    print("serverStatus")
                    self.version.text = serverStatus.getString()
                }
            }
        }
    }

    fileprivate func redirectIfAuthenticated() {
        if Settings.access_token != nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateInitialViewController() {
                if let nc = self.navigationController {
                    nc.pushViewController(vc, animated: true)
                } else {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    DispatchQueue.main.async {
                        appDelegate.window?.rootViewController = vc
                    }
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // redirectIfAuthenticated()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("AuthVC.viewDidLoad")
        initSettings()
        redirectIfAuthenticated()
    }

    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if let ident = identifier {
            return ident == "settingsSegue" || Settings.access_token != nil
        }
        return true
    }
}
