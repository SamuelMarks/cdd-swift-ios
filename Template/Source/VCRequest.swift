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
    var btnTagsToField: [Int:(APIFieldD,UIStackView)] = [:]
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
        request.fields.forEach { self.stackView.addArrangedSubview(viewForField($0))}
        
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
        btn.addTarget(self, action: #selector(run), for: .touchUpInside)
        stackView.addArrangedSubview(btn)
    }
    
    func viewForField(_ field: APIFieldD) -> UIView {
        let view = UIView()
        
        let label = UILabel()
        label.text = field.name
        view.addSubview(label)
        label.easy.layout([Left(),Top(),Height(40),Width(100)])
        
        let descLabel = UILabel()
        descLabel.text = field.type
        descLabel.textColor = .darkGray
        view.addSubview(descLabel)
        descLabel.easy.layout([Top(),Left(10).to(label),Height(40)])
        
        let fieldsStackView = UIStackView()
        fieldsStackView.axis = .vertical
        view.addSubview(fieldsStackView)
        fieldsStackView.easy.layout(Left(10).to(label),Right(),Top().to(descLabel),Bottom())
        
        if field.isArray {
            let btn = addItemToArrayButton()
            btnTagsToField[btn.tag] = (field,fieldsStackView)
            fieldsStackView.addArrangedSubview(btn)
        }
        else
        if field.isSimple {
            let view = viewForSimpleField(type:field.clearType)
            fieldsStackView.addArrangedSubview(view)
        }
        else {
            if let model = VCRequests.models.first(where: { (model) -> Bool in
                return model.name == field.clearType
            }) {
                model.fields.forEach({fieldsStackView.addArrangedSubview(self.viewForField($0))})
            }
        }
        
        return view
    }
    
    func viewForSimpleField(type: String) -> UIView {
        let tf = UITextField()
        view.addSubview(tf)
        tf.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        tf.easy.layout([Height(40)])
        return tf
    }
    
    func addItemToArrayButton() -> UIButton {
        let btn = UIButton()
        btn.easy.layout(Height(30))
        btn.setTitle("+", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        btn.setTitleColor(.darkGray, for: .normal)
        btn.tag = Int.random(in: 1000..<9999)
        btn.addTarget(self, action: #selector(onAddItemToArray(_:)), for: .touchUpInside)
        return btn
    }
    
    @objc func onAddItemToArray(_ button: UIButton) {
        guard let tuple = btnTagsToField[button.tag] else { return }
        let field = tuple.0
        let fieldsStackView = tuple.1
        
        if field.isSimple {
            let view = viewForSimpleField(type:field.clearType)
            fieldsStackView.insertArrangedSubview(view, at: fieldsStackView.arrangedSubviews.count - 1)
        }
        else {
            if let model = VCRequests.models.first(where: { (model) -> Bool in
                return model.name == field.clearType
            }) {
                model.fields.forEach {
                    fieldsStackView.insertArrangedSubview(self.viewForField($0), at: fieldsStackView.arrangedSubviews.count - 1)
                }
            }
        }
        
        fieldsStackView.insertArrangedSubview(separator(), at: fieldsStackView.arrangedSubviews.count - 1)
    }
    
    @objc func run() {
        
    }
    
    func separator() -> UIView {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.easy.layout(Height(1))
        return view
    }
    
    func responseView() -> UIView {
        let tv = UITextView()
        tv.easy.layout(Height(200))
        
        return tv
    }
}
