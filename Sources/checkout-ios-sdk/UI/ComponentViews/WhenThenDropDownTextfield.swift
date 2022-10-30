//
//  File.swift
//  
//
//  Created by Elikem Savie on 12/10/2022.
//

import Foundation
import UIKit

class WhenThenDropDownTextfield: UIView {
    
    enum Usecase {
        case date
        case normal
    }

    var didTapContainer: (() -> Void)?
    var onPickerDoneSelected: (() -> Void)?
    var didPickHandler: ((_ title: String, _ index: Int) -> Void)?

    var showDropDownIcon = true
    private var selectedItem: String = ""
    private var index: Int = 0
    
    lazy var pickerView = UIPickerView()
    
    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.overrideUserInterfaceStyle = .light
        picker.datePickerMode = .date
        picker.minimumDate = Date()
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        }
        return picker
    }()
    
    var text: String? {
        get {
            return textfield.text?.trimmingCharacters(in: .whitespaces)
        }
        set {
            textfield.text = newValue
            updateViewWith(state: .inactive)
        }
    }

    var data: [String] = [] {
        didSet {
            if !data.isEmpty {
                selectedItem = data.first!
            }
        }
    }

    var date: Date? {
        didSet {
            textfield.text = date?.string(format: "MM/YY")
        }
    }

    var errorText: String? {
        didSet {
            errorLabel.text = errorText
        }
    }

    private lazy var errorLabel = UILabel.create(
        text: "",
        color: .red,
        font: .systemFont(ofSize: 11)
    )

    var usecase: Usecase = .normal

    lazy var textfield: UITextField = {
        let view = UITextField()
        view.tintColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(didBeginEditing), for: .editingDidBegin)
        view.addTarget(self, action: #selector(didEndEditing), for: .editingDidEnd)

        return view
    }()

    lazy var containerView: UIView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.down"))
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true

        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 8
        view.heightAnchor.constraint(equalToConstant: 60).isActive = true

        view.addSubview(imageView)
        view.addSubview(textfield)
        textfield.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        textfield.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        textfield.rightAnchor.constraint(equalTo: imageView.leftAnchor, constant: -8).isActive = true

        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        
        imageView.isHidden = !showDropDownIcon

        return view
    }()
    
    private lazy var vStack = UIStackView.create(
        spacing: 4,
        axis: .vertical,
        alignment: .fill,
        distribution: .fill,
        views: [containerView, errorLabel]
    )

    lazy var pickerToolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(
            title: "Done",
            style: .done,
            target: nil,
            action: #selector(didPressDone)
        )
        toolbar.items = [
            UIBarButtonItem(
                barButtonSystemItem: .flexibleSpace,
                target: nil,
                action: nil
            ),
            doneButton
        ]
        return toolbar
    }()

    init(
        placeholderText: String? = nil,
        showDropDownIcon: Bool = true,
        usecase: Usecase = .normal,
        textfieldDelegate: UITextFieldDelegate? = nil
    ) {
        self.showDropDownIcon = showDropDownIcon
        self.usecase = usecase
        super.init(frame: .zero)
        setupView()

        textfield.delegate = textfieldDelegate

        switch usecase {
        case .date:
            setupDatePicker()
        case .normal:
            setupPicker()
        }

        addtTapGestures()
        self.setPlaceHolder(with: placeholderText)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(vStack)
        vStack.topAnchor.constraint(equalTo: topAnchor).isActive = true
        vStack.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        vStack.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        vStack.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        self.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }

    func updateViewWith(state: TextFieldState) {
        containerView.layer.borderWidth = 1
        switch state {
        case .error:
            containerView.layer.borderColor = UIColor.red.cgColor
        case .active:
            containerView.layer.borderColor = UIColor.blue.cgColor
            errorText = " "
        case .highlighted:
            containerView.layer.borderColor = UIColor.blue.cgColor
            containerView.layer.borderWidth = 4
            errorText = " "
        case .inactive:
            containerView.layer.borderColor = UIColor.gray.cgColor
            errorText = " "
        case .greyedOut:
            containerView.layer.borderColor = UIColor.gray.cgColor
            containerView.backgroundColor = UIColor.gray
            errorText = " "
        }
    }

    func setupPicker() {
        pickerView.delegate = self
        pickerView.dataSource = self
        textfield.inputView = pickerView
        textfield.inputAccessoryView = pickerToolbar
    }

    private func setupDatePicker() {
        textfield.inputView = datePicker
        datePicker.minimumDate = nil
        textfield.inputAccessoryView = pickerToolbar
    }

    private func addtTapGestures() {
        addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(didTapSelf)
        ))
    }
    
    func setPlaceHolder(with text: String?) {
        let placeholderText = NSAttributedString(
            string: text ?? "",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        textfield.attributedPlaceholder = placeholderText
    }

    func update(with data: [String]) {
        self.data = data
        pickerView.reloadAllComponents()
    }

    func setResponsder() {
        textfield.becomeFirstResponder()
    }

    @objc private func didTapSelf() {
        didTapContainer?()
    }

    @objc private func didBeginEditing() {
        updateViewWith(state: .active)
    }

    @objc private func didEndEditing() {
        updateViewWith(state: .inactive)
    }

    @objc private func didPressDone() {
        textfield.resignFirstResponder()
        
        switch usecase {
        case .normal:
            onPickerDoneSelected?()
        case .date:
            date = datePicker.date
        }
    }

    
}

extension WhenThenDropDownTextfield: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let handler = didPickHandler {
            handler(data[row], row)
        }
        return data[row]
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row < data.count {
            let option = data[row]
            selectedItem = option
            index = row
            self.text = option
        }
    }

}
