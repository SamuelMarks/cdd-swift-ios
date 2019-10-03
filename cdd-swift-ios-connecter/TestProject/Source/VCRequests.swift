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
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Requests"
        if let url = Bundle.main.url(forResource: "TestObjects", withExtension: "string"),
            let jsonData = try? Data(contentsOf: url),
            let objects = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String:Any] {
            
            let decoder = JSONDecoder()
            
                
            if let modelsJSON = objects["models"] as? [[String:Any]] {
                Core.models = modelsJSON.compactMap {
                    try? decoder.decode(Model.self, from: JSONSerialization.data(withJSONObject: $0, options: .prettyPrinted))
                }
            }
            if let requestsJSON = objects["requests"] as? [[String:Any]] {
                
                Core.requests = requestsJSON.compactMap {
                    try? decoder.decode(Request.self, from: JSONSerialization.data(withJSONObject: $0, options: .prettyPrinted))
                }
            }
        }
        
        view.addSubview(tableView)
    }
    
    @IBAction func segmentControlChanged(_ sender: Any) {
        tableView.reloadData()
    }
}

extension VCRequests: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return segmentControl.selectedSegmentIndex == 0 ? Core.requests.count : Core.models.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if segmentControl.selectedSegmentIndex == 0 {
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "VCRequest") as? VCRequest else { return }
            vc.request = Core.requests[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "VCRequestsForModel") as? VCRequestsForModel else { return }
            vc.model = Core.models[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kCell", for: indexPath)
        cell.textLabel?.text = segmentControl.selectedSegmentIndex == 0 ? Core.requests[indexPath.row].urlPath : Core.models[indexPath.row].name
        return cell
    }
}
