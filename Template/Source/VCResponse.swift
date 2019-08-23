//
//  VCResponse.swift
//  ios
//
//  Created by Alexei on 14/08/2019.
//  Copyright © 2019 Alexei. All rights reserved.
//

import UIKit

class VCResponse: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var json: Any!
    var request: Request!
    
    var source: [(String,Model)] = []
    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.isHidden = true
        
        guard  let json = json else {
            return
        }
        textView.text = (json as AnyObject).debugDescription
        
        guard let model = Core.models.first(where: {$0.name == request.responseType})else { return }
        
        if request.responseType.hasPrefix("[") {
            if let arr = json as? [[String:Any]] {
                source = arr.compactMap({
                    if let id = findId(json: $0, model: model) {
                        return (id,model)
                    }
                    return nil
                })
            }
        }
        else {
            if let json = json as? [String: Any], let id = findId(json: json, model: model) {
                source = [(id,model)]
            }
        }
        tableView.reloadData()
    }
    @IBAction func onSegmentChanged(_ sender: UISegmentedControl) {
        tableView.isHidden = sender.selectedSegmentIndex == 0 
    }
    
    func findId(json: [String:Any],model: Model) -> String? {
        guard let restId = model.restId else { return nil }
        if let id = json[restId] as? String {
            return id
        }
        if let id = json[restId] as? Int {
            return "\(id)"
        }
        return nil
    }
}

extension VCResponse: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return source.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kCell", for: indexPath)
        let model = source[indexPath.row].1
        cell.textLabel?.text = [model.name," \(model.restId ?? ""):",source[indexPath.row].0].joined(separator: " ")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
     
    }
}
