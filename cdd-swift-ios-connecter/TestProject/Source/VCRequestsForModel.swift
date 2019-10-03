//
//  VCRequestsForModel.swift
//  ios
//
//  Created by Alexei on 16/08/2019.
//  Copyright © 2019 Alexei. All rights reserved.
//

import UIKit

class VCRequestsForModel: UIViewController {
    var model: Model!
    @IBOutlet weak var tableView: UITableView!
    
    var source: [(String,Request)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "REST Requests for " + model.name
        let endpoint = model.name.lowercased() + "s"
        
        Core.requests.forEach { (request) in
            var comps = request.urlPath.components(separatedBy: "/")
            if comps.last == "" {
                comps.removeLast()
            }
            if comps.last == endpoint {
                self.source.append(("List all", request))
            }
            if comps.last?.contains("{") == true {
                comps.removeLast()
                if comps.last == endpoint {
                    switch request.method {
                    case .get:
                        self.source.append(("Get", request))
                    case .post:
                        self.source.append(("Post", request))
                    case .put:
                        self.source.append(("Update", request))
                    case .delete:
                        self.source.append(("Remove", request))
                    }
                }
            }
        }
        
        tableView.reloadData()
    }
}

extension VCRequestsForModel: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return source.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kCell", for: indexPath)
        cell.textLabel?.text = source[indexPath.row].0
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "VCRequest") as? VCRequest else { return }
        vc.request = source[indexPath.row].1
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
