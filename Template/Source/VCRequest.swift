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

    var varsToStackView: [String:UIStackView] = [:]
    var btnTagsToField: [Int:(Variable,UIStackView)] = [:]
    var request: Request!
    var stackView = UIStackView()
    var scrollView = UIScrollView()
    
    var pickerBool = UIPickerView()
    var tfToType: [UITextField:PrimitiveType] = [:]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.easy.layout(Left(20),Right(20),Top(),Bottom())
        
        scrollView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.easy.layout([Edges(),Width().like(scrollView)])
        
        addLabel(request.urlPath).textAlignment = .center
        request.vars.forEach { self.stackView.addArrangedSubview(viewForField($0))}
        
        pickerBool.delegate = self
        pickerBool.dataSource = self
    }
    @IBAction func execute(_ sender: Any) {
        view.showActivity()
        execute(onResult: {[weak self] (json) in
            self?.view.hideActivity()
            guard let vc = self?.storyboard?.instantiateViewController(withIdentifier: "VCResponse") as? VCResponse else { return }
            vc.json = json
            self?.navigationController?.pushViewController(vc, animated: true)
        }) {[weak self] (error) in
            self?.view.hideActivity()
            print(error)
        }
    }

    func addLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        
        stackView.addArrangedSubview(label)
        return label
    }
    
    func viewForField(_ field: Variable) -> UIView {
        let view = UIView()
        
        let label = UILabel()
        label.text = field.name
        view.addSubview(label)
        label.easy.layout([Left(),Top(),Height(40),Width(<=100)])
        
        if !field.optional {
            let lblRequired = UILabel()
            lblRequired.text = "*"
            lblRequired.textColor = .red
            view.addSubview(lblRequired)
            lblRequired.easy.layout([Left(4).to(label),Top(5)])
        }
        
        let descLabel = UILabel()
        descLabel.text = field.type.rawValue
        descLabel.textColor = .darkGray
        view.addSubview(descLabel)
        descLabel.easy.layout([Top(),Left(110),Height(40), Right()])
        
        let fieldsStackView = UIStackView()
        fieldsStackView.axis = .vertical
        view.addSubview(fieldsStackView)
        fieldsStackView.easy.layout(Left(110),Right(),Top().to(descLabel),Bottom())
        
        varsToStackView[field.name] = fieldsStackView
        switch field.type {
        case .primitive(let type):
            let view = viewForSimpleField(type:type)
            fieldsStackView.addArrangedSubview(view)
        case .array(_):
            let btn = addItemToArrayButton()
            btnTagsToField[btn.tag] = (field,fieldsStackView)
            fieldsStackView.addArrangedSubview(btn)
        case .complex(_):
            break
//            if let model = VCRequests.models.first(where: { (model) -> Bool in
//                return model.name == typeName
//            }) {
//                model.vars.forEach({fieldsStackView.addArrangedSubview(self.viewForField($0))})
//            }
        }
        
        return view
    }
    
    func viewForSimpleField(type: PrimitiveType) -> UIView {
        let tf = UITextField()
        view.addSubview(tf)
        tf.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
        tf.leftViewMode = .always
        tf.easy.layout([Height(40)])
        tf.delegate = self
        tfToType[tf] = type
        switch type {
        case .Bool:
            tf.inputView = pickerBool
        case .Float:
            tf.keyboardType = .decimalPad
        case .Int:
            tf.keyboardType = .numberPad
        case .String: break
        }
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
        
        guard case .array(let type) = field.type else { return }
        
        switch type {
        case .primitive(let type):
            let view = viewForSimpleField(type:type)
            fieldsStackView.insertArrangedSubview(view, at: fieldsStackView.arrangedSubviews.count - 1)
        case .array(_):
          break
        case .complex(let typeName):
            if let model = VCRequests.models.first(where: { (model) -> Bool in
                return model.name == typeName
            }) {
                model.vars.forEach {
                    fieldsStackView.insertArrangedSubview(self.viewForField($0), at: fieldsStackView.arrangedSubviews.count - 1)
                }
            }
        }
        
        fieldsStackView.insertArrangedSubview(separator(), at: fieldsStackView.arrangedSubviews.count - 1)
        
        fieldsStackView.layoutIfNeeded()
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

extension VCRequest: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ["True","False"][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tfToType.keys.forEach {
            if $0.isFirstResponder {
                $0.text = ["True","False"][row]
            }
        }
        
        view.endEditing(true)
    }
}

extension VCRequest: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let type = tfToType[textField] {
            if type == .Float {
                let comps = (textField.text ?? "").components(separatedBy: ".")
                if comps.count > 2 {
                    textField.text = comps[0] + "." + comps[1]
                }
            }
        }
    }
}

extension Type {
    var rawValue: String {
        switch self {
        case .primitive(let type):
            return type.rawValue
        case .array(let type):
            return "[" + type.rawValue + "]"
        case .complex(let type):
            return type
        }
    }
}
