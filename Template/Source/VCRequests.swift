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
    static var models: [Model] = []
    @IBOutlet var tableView: UITableView!
    var requests:[Request] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Requests"
        if let url = Bundle.main.url(forResource: "TestObjects", withExtension: "string"),
            let jsonData = try? Data(contentsOf: url),
            let objects = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String:Any] {
            
            let decoder = JSONDecoder()
            
                
            if let modelsJSON = objects["models"] as? [[String:Any]] {
                VCRequests.models = modelsJSON.compactMap {
                    try? decoder.decode(Model.self, from: JSONSerialization.data(withJSONObject: $0, options: .prettyPrinted))
                }
            }
            if let requestsJSON = objects["requests"] as? [[String:Any]] {
                
                requests = requestsJSON.compactMap {
                    try? decoder.decode(Request.self, from: JSONSerialization.data(withJSONObject: $0, options: .prettyPrinted))
                }
            }
        }
        
        view.addSubview(tableView)
        
        
    }
}

extension VCRequests: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "VCRequest") as? VCRequest else { return }
        vc.request = requests[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kCell", for: indexPath)
        cell.textLabel?.text = requests[indexPath.row].urlPath
        return cell
    }
}
