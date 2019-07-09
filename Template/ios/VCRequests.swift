//
//  VCRequests.swift
//  ios
//
//  Created by Alexei on 04/07/2019.
//  Copyright © 2019 Alexei. All rights reserved.
//

import UIKit
import EasyPeasy

class VCRequests: UIViewController {
    static var models: [APIModelD] = [APIModelD(name: "Person", fields: [APIFieldD(name: "name", type: "string"),APIFieldD(name: "age", type: "int")])]
    var tableView = UITableView()
    var requests:[APIRequestD] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "kCell")
        tableView.easy.layout(Edges())
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension VCRequests: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = VCRequest()
        vc.request = requests[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kCell", for: indexPath)
        cell.textLabel?.text = requests[indexPath.row].path
        return cell
    }
}
