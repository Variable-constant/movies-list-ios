//
//  InputField.swift
//  ios-itmo-2022-assignment2
//
//  Created by Andrey Karpenko on 01.12.2022.
//

import UIKit

class InputField: UIView, UITextFieldDelegate {
    private var onEndEditing: () -> () = {}
    private var validationFunc: (String) -> Bool = {s in return !s.isEmpty }
    var isValid = false
    
    private lazy var fieldTitle: UILabel = {
        let fieldTitle = UILabel()
        fieldTitle.translatesAutoresizingMaskIntoConstraints = false
        fieldTitle.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.regular)
        fieldTitle.textColor = .systemGray
        return fieldTitle
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.autocorrectionType = .no
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemGray6
        textField.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldNeedValidation), for: .editingChanged)
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 6
        textField.layer.borderColor = UIColor.systemGray4.cgColor
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(fieldTitle)
        addSubview(textField)
        
        NSLayoutConstraint.activate([
            fieldTitle.topAnchor.constraint(equalTo: topAnchor),
            fieldTitle.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            textField.topAnchor.constraint(equalTo: fieldTitle.bottomAnchor, constant: 8),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
            textField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureView(title: String, placeholder: String, _ onEndEditing: @escaping () -> ()) {
        fieldTitle.text = title
        textField.placeholder = placeholder
        self.onEndEditing = onEndEditing
    }
    
    func configureValidation(validationFunc: @escaping (String) -> Bool) {
        self.validationFunc = validationFunc
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.onEndEditing()
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.onEndEditing()
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textFieldNeedValidation()
        return true
    }
    
    @objc
    func textFieldNeedValidation() {
        isValid = validationFunc(textField.text ?? "")
        if isValid {
            textField.layer.borderColor = UIColor.systemGray4.cgColor
        } else {
            textField.layer.borderColor = UIColor.red.cgColor
        }
        self.onEndEditing()
    }
}
