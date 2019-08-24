//
//  VCResponse.swift
//  ios
//
//  Created by Alexei on 14/08/2019.
//  Copyright © 2019 Alexei. All rights reserved.
//

import UIKit

class VCResponse: UIViewController {
    var json: Any!
    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard  let json = json else {
            return
        }
        textView.text = (json as AnyObject).debugDescription
    }
}
