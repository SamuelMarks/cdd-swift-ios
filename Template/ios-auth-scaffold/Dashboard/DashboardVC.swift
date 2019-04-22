//
//  ViewController.swift
//  ios-auth-scaffold
//
//  Created by Samuel Marks on 18/2/18.
//  Copyright © 2018 Samuel Marks. All rights reserved.
//

import UIKit

class DashboardVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        redirectIfUnauthenticated()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func onLogout(_ sender: UIButton) {
        Settings.access_token = nil
        redirectIfUnauthenticated()
    }
}

