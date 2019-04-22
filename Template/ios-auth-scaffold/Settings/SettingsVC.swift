//
//  SettingsVC.swift
//  ios-auth-scaffold
//
//  Created by Samuel Marks on 18/2/18.
//  Copyright © 2018 Samuel Marks. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
    @IBOutlet weak var hostname: UITextField!
    @IBOutlet weak var route: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
    }

    override func removeFromParent() {
        super.removeFromParent()
    }

    @IBAction func hostnameEditBegun(_ sender: UITextField) {
        route.isEnabled = true
    }

    @IBAction func onSubmit(_ sender: UIButton) {
        Settings.hostname = hostname.text!
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func hostnamePrimaryAction(_ sender: UITextField) {
        route.sendActions(for: .touchUpInside)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    /*@IBAction func unwindFromSettingsVC(unwindSegue: UIStoryboardSegue) {
        print("SettingsVC.unwindFromSettingsVC")
    }*/
}
