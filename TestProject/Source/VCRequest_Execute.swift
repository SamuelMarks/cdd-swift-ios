//
//  VCRequest_Execute.swift
//  ios
//
//  Created by Alexei on 14/08/2019.
//  Copyright © 2019 Alexei. All rights reserved.
//

import UIKit
import Alamofire



extension VCRequest {
    
    func extractVarValue(type:Type, stackView: UIStackView) -> Any? {
        
        let extractTFData: (PrimitiveType,String)-> Any? = {
            switch $0 {
            case .Bool:
                return $1 == "True"
            case .Float:
                return Float($1)
            case .Int:
                return Int($1)
            case .String:
                return $1
            }
        }
        
        switch type {
        case .primitive(let type):
            if let tf = stackView.arrangedSubviews.first(where: {$0 is UITextField}) as? UITextField, let text = tf.text, text.count > 0 {
                return extractTFData(type,text)
            }
        case .array(let type):
            if case .primitive(let type) = type {
                var res: [Any] = []
                stackView.arrangedSubviews.forEach {
                    if let tf = $0 as? UITextField,let text = tf.text, text.count > 0, let value = extractTFData(type,text) {
                        res.append(value)
                    }
                }
                return res
            }
        case .complex: break
        }
        
        return nil
    }
}
