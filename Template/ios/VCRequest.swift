//
//  VCRequest.swift
//  ios
//
//  Created by Alexei on 04/07/2019.
//  Copyright © 2019 Alexei. All rights reserved.
//

import UIKit
import EasyPeasy

class VCRequest: UIViewController {
    var request: APIRequestD!
    var stackView = UIStackView()
    var scrollView = UIScrollView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.easy.layout(Left(20),Right(20),Top(),Bottom())
        
        scrollView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.easy.layout([Edges(),Width().like(scrollView)])
        
        addLabel(request.path).textAlignment = .center
        request.fields.forEach { addField($0)}
        
        addRunButton()
    }

    func addLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        
        stackView.addArrangedSubview(label)
        return label
    }
    
    func addRunButton() {
        let btn = UIButton()
        btn.easy.layout(Height(30))
        btn.setTitle("Execute", for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        stackView.addArrangedSubview(btn)
    }
    
    func addField(_ field: APIFieldD) {
        if field.isSimple {
            let view = UIView()
            stackView.addArrangedSubview(view)
            view.easy.layout(Height(40))
            let label = UILabel()
            label.text = field.name
            view.addSubview(label)
            label.easy.layout([Left(),Top(),Bottom()])
            
            let tf = UITextField()
            view.addSubview(tf)
            tf.backgroundColor = UIColor.black.withAlphaComponent(0.1)
            tf.easy.layout([Top(5),Bottom(5),Left(10).to(label), Width(*0.5).like(view)])
            let descLabel = UILabel()
            descLabel.text = field.type
            descLabel.textColor = .darkGray
            view.addSubview(descLabel)
            descLabel.easy.layout([Top(),Bottom(),Left(10).to(tf)])
        }
    }
}
