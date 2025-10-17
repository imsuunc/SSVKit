import UIKit
#if canImport(SSFoundation)
@_exported import SSFoundation
#endif

enum MaterialTextFieldStyle {
    case filled
    case outlined
}

enum MaterialTextFieldValidate {
    case none
    case notEmpty
    case onlyNumbers
    case onlyLetters
    case phoneNumber
    case email
}

class MaterialTextFieldConfigure {
    var maxLength: UInt64 = .max
    var placeholder: String? = nil
    var placeholderColor: UIColor = UIColor.color("#757575") // Material Grey 600
    var style: MaterialTextFieldStyle = .filled
    var validate: MaterialTextFieldValidate = .notEmpty
    var focusRadius: CGFloat = 12
    // TEXT
    var defaultText: String? = nil
    var textFont: UIFont = .systemFont(ofSize: 16)
    var errorTextColor: UIColor = UIColor.color("#212121") // Material Grey 900
    var normalTextColor: UIColor = UIColor.color("#212121") // Material Grey 900
    var editingTextColor: UIColor = UIColor.color("#212121") // Material Grey 900
    var isSecureTextEntry: Bool = false
    var keyboardType: UIKeyboardType = .default
    // TITLE
    var titleFont: UIFont = .systemFont(ofSize: 12)
    var errorTitleColor: UIColor = UIColor.color("#757575") // Material Grey 600
    var normalTitleColor: UIColor = UIColor.color("#757575") // Material Grey 600
    var editingTitleColor: UIColor = UIColor.color("#1976D2") // Material Blue 700
    // FOCUS
    var errorFocusColor: UIColor = UIColor.color("#FFEBEE") // Material Red 50
    var normalFocusColor: UIColor = UIColor.color("#F5F5F5") // Material Grey 100
    var editingFocusColor: UIColor = UIColor.color("#E3F2FD") // Material Blue 50
    // Underline
    var errorUnderlineColor: UIColor = UIColor.color("#D32F2F") // Material Red 700
    var normalUnderlineColor: UIColor = UIColor.color("#BDBDBD") // Material Grey 400
    var editingUnderlineColor: UIColor = UIColor.color("#1976D2") // Material Blue 700
    // Error Message
    var errorMessageFont: UIFont = .systemFont(ofSize: 12)
    var errorMessageColor: UIColor = UIColor.color("#D32F2F") // Material Red 700
    // Outline
    var outlineWidth: CGFloat = 1
    var outlineColor: UIColor = UIColor.color("#BDBDBD") // Material Grey 400
    var outlineErrorColor: UIColor = UIColor.color("#D32F2F") // Material Red 700
    var outlineEditingColor: UIColor = UIColor.color("#1976D2") // Material Blue 700
}

class MaterialTextField: UIView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = configure.normalTitleColor
        label.font = configure.titleFont
        label.text = configure.placeholder
        label.backgroundColor = .clear
        return label
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = configure.normalTitleColor
        label.font = configure.textFont
        label.text = configure.placeholder
        label.backgroundColor = .clear
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.textColor = configure.normalTextColor
        textField.font = configure.textFont
        textField.keyboardType = configure.keyboardType
        textField.isSecureTextEntry = configure.isSecureTextEntry
        textField.delegate = self
        textField.semanticContentAttribute = .forceRightToLeft
        textField.backgroundColor = .clear
        return textField
    }()
    
    private lazy var errorMessageLabel: UILabel = {
        let label = UILabel()
        label.textColor = configure.errorMessageColor
        label.font = configure.errorMessageFont
        label.backgroundColor = .clear
        label.isHidden = true
        return label
    }()
    
    private lazy var focusView: UIView = {
        let view = UIView()
        view.backgroundColor = configure.normalFocusColor
        return view
    }()
    
    private lazy var underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = configure.normalUnderlineColor
        return view
    }()
    
    private lazy var outlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = configure.outlineWidth
        view.layer.borderColor = configure.outlineColor.cgColor
        view.layer.cornerRadius = configure.focusRadius
        return view
    }()
    
    private lazy var clearButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    var onDidBeginEditing: (() -> Void)?
    var onDidEndEditing: ((String) -> Void)?
    
    private(set) var currentValue: String?
    private var configure: MaterialTextFieldConfigure = .init()
    
    init(configure: MaterialTextFieldConfigure) {
        self.configure = configure
        super.init(frame: .zero)
        renderView()
        bindData()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
        renderView()
        bindData()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .red
        renderView()
        bindData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        focusView.layer.cornerRadius = configure.focusRadius
        focusView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    private func renderView() {
        addSubview(focusView)
        focusView.edgesToSuperview()
        focusView.layer.cornerRadius = configure.focusRadius
        
        if configure.style == .outlined {
            addSubview(outlineView)
            outlineView.edgesToSuperview()
            outlineView.layer.cornerRadius = configure.focusRadius
        }
        
        addSubview(underlineView)
        if configure.style == .filled {
            underlineView.edgesToSuperview(excluding: .top)
            underlineView.height(1)
        } else {
            underlineView.isHidden = true
        }
        
        let stackView = UIStackView(arrangedSubviews: [clearButton])
        addSubview(stackView)
        clearButton.aspectRatio(1)
        stackView.topToSuperview(offset: 8)
        stackView.trailingToSuperview(offset: 8)
        if configure.style == .filled {
            stackView.bottomToTop(of: underlineView, offset: -8)
        } else {
            stackView.bottomToSuperview(offset: -8)
        }
        
        addSubview(textField)
        textField.bottomToTop(of: underlineView, offset: -8)
        textField.leadingToSuperview(offset: -16)
        textField.trailingToLeading(of: stackView, offset: -8)
        textField.trailingToSuperview(offset: 16, relation: .equalOrGreater, priority: .defaultLow)
        
        addSubview(placeholderLabel)
        placeholderLabel.bottomToTop(of: underlineView, offset: -8)
        placeholderLabel.leadingToSuperview(offset: 16)
        placeholderLabel.trailingToLeading(of: stackView, offset: -8)
        placeholderLabel.trailingToSuperview(offset: 16, relation: .equalOrGreater, priority: .defaultLow)
        placeholderLabel.isHidden = configure.defaultText?.isEmpty == false
        if configure.defaultText?.isEmpty == false {
            titleLabel.isHidden = false
            placeholderLabel.isHidden = true
        } else {
            titleLabel.isHidden = true
            placeholderLabel.isHidden = false
        }
        addSubview(titleLabel)
        titleLabel.topToSuperview(offset: 8)
        titleLabel.bottomToTop(of: textField)
        titleLabel.leadingToSuperview(offset: 16)
        titleLabel.trailingToLeading(of: stackView, offset: -8)
        titleLabel.trailingToSuperview(offset: -16, relation: .equalOrGreater, priority: .defaultLow)
        titleLabel.isHidden = !(configure.defaultText?.isEmpty == false)
        
        addSubview(errorMessageLabel)
        errorMessageLabel.topToBottom(of: configure.style == .filled ? underlineView : outlineView, offset: 4)
        errorMessageLabel.leadingToSuperview(offset: 16)
        errorMessageLabel.trailingToSuperview(offset: -16)
        errorMessageLabel.bottomToSuperview(offset: -4)
    }
    
    private func bindData() {
        currentValue = configure.defaultText
        if let text = configure.defaultText, text.isEmpty == false {
            textField.text = text
        } else {
            placeholderLabel.text = configure.placeholder
        }
    }
    
}

extension MaterialTextField {
    
    private func validateText(_ text: String) {
        var isValid = true
        var errorMessage: String? = nil
        
        switch configure.validate {
        case .none:
            isValid = true
        case .notEmpty:
            isValid = !text.isEmpty
            if !isValid {
                errorMessage = "This field is required"
            }
        case .onlyNumbers:
            isValid = text.isEmpty || text.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
            if !isValid {
                errorMessage = "Only numbers are allowed"
            }
        case .onlyLetters:
            isValid = text.isEmpty || text.rangeOfCharacter(from: CharacterSet.letters.inverted) == nil
            if !isValid {
                errorMessage = "Only letters are allowed"
            }
        case .phoneNumber:
            let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
            let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
            isValid = text.isEmpty || phonePredicate.evaluate(with: text)
            if !isValid {
                errorMessage = "Invalid phone number"
            }
        case .email:
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            isValid = text.isEmpty || emailPredicate.evaluate(with: text)
            if !isValid {
                errorMessage = "Invalid email address"
            }
        }
        
        // Update UI based on validation state
        if text.isEmpty {
            titleLabel.isHidden = true
            placeholderLabel.isHidden = false
            placeholderLabel.transform = .identity
            placeholderLabel.font = self.configure.textFont
        } else {
            titleLabel.isHidden = false
            placeholderLabel.isHidden = true
            placeholderLabel.transform = .identity
            placeholderLabel.font = self.configure.textFont
        }
        
        if isValid {
            textField.textColor = configure.normalTextColor
            titleLabel.textColor = configure.normalTitleColor
            focusView.backgroundColor = configure.normalFocusColor
            if configure.style == .filled {
                underlineView.backgroundColor = configure.normalUnderlineColor
            } else {
                outlineView.layer.borderColor = configure.outlineColor.cgColor
            }
            titleLabel.text = configure.placeholder
            errorMessageLabel.isHidden = true
        } else {
            textField.textColor = configure.errorTextColor
            titleLabel.textColor = configure.errorTitleColor
            focusView.backgroundColor = configure.errorFocusColor
            if configure.style == .filled {
                underlineView.backgroundColor = configure.errorUnderlineColor
            } else {
                outlineView.layer.borderColor = configure.outlineErrorColor.cgColor
            }
            titleLabel.text = configure.placeholder
            errorMessageLabel.text = errorMessage
            errorMessageLabel.isHidden = false
        }
    }
    
}

extension MaterialTextField {
    
    @objc private func clearButtonTapped() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.textField.text = nil
            self.currentValue = nil
            self.titleLabel.isHidden = true
            self.placeholderLabel.isHidden = false
            self.placeholderLabel.font = self.configure.textFont
            self.placeholderLabel.transform = .identity
        }
    }
    
}

extension MaterialTextField: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        onDidBeginEditing?()
        clearButton.isHidden = false
        textField.text = self.currentValue
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            var transform = CGAffineTransform.identity
            transform = CGAffineTransform.init(translationX: -0, y: -self.titleLabel.bounds.height)
            self.placeholderLabel.font = self.configure.titleFont
            self.placeholderLabel.transform = transform
            self.titleLabel.textColor = self.configure.editingTitleColor
            self.focusView.backgroundColor = self.configure.editingFocusColor
            if self.configure.style == .filled {
                self.underlineView.backgroundColor = self.configure.editingUnderlineColor
            } else {
                self.outlineView.layer.borderColor = self.configure.outlineEditingColor.cgColor
            }
        } completion: { success in
            if success {
                self.placeholderLabel.isHidden = true
                self.titleLabel.isHidden = false
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        onDidEndEditing?(currentValue ?? "")
        currentValue = textField.text
        clearButton.isHidden = true
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.validateText(textField.text ?? "")
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Get the current text and the new text that would result from this change
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        // Check max length first
        if configure.maxLength > 0, newText.utf8.count > configure.maxLength {
            return false
        }
        
        // Handle validation based on type
        switch configure.validate {
        case .none:
            return true
            
        case .notEmpty:
            return true
            
        case .onlyNumbers:
            // Allow empty string and only decimal digits
            if string.isEmpty { return true }
            let numberSet = CharacterSet.decimalDigits
            return string.rangeOfCharacter(from: numberSet.inverted) == nil
            
        case .onlyLetters:
            // Allow empty string and only letters
            if string.isEmpty { return true }
            let letterSet = CharacterSet.letters
            return string.rangeOfCharacter(from: letterSet.inverted) == nil
            
        case .phoneNumber:
            // Allow empty string
            if string.isEmpty { return true }
            
            // Allow only digits and plus sign
            let phoneSet = CharacterSet(charactersIn: "0123456789+")
            if string.rangeOfCharacter(from: phoneSet.inverted) != nil {
                return false
            }
            
            // Special handling for plus sign
            if string == "+" {
                // Only allow plus sign at the start
                return range.location == 0
            }
            
            // If adding a digit, check if it would exceed max length
            if string.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil {
                let digitsOnly = newText.filter { $0.isNumber }
                return digitsOnly.count <= 16
            }
            
            return true
            
        case .email:
            // Allow empty string
            if string.isEmpty { return true }
            
            // Allow letters, numbers, and special characters for email
            let emailSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.@_+-")
            if string.rangeOfCharacter(from: emailSet.inverted) != nil {
                return false
            }
            
            // Special handling for @ symbol
            if string == "@" {
                // Don't allow multiple @ symbols
                return !newText.contains("@")
            }
            
            // Special handling for dots
            if string == "." {
                // Don't allow consecutive dots
                if let lastChar = newText.dropLast().last, lastChar == "." {
                    return false
                }
                // Don't allow dot right after @
                if let lastChar = newText.dropLast().last, lastChar == "@" {
                    return false
                }
            }
            
            return true
        }
    }
    
}

#if DEBUG

import SwiftUI

fileprivate class PreviewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let configure = MaterialTextFieldConfigure()
        configure.placeholder = "Price"
        configure.validate = .email
        let textField = MaterialTextField(configure: configure)
        view.addSubview(textField)
    
        textField.centerInSuperview()
        textField.leadingToSuperview(offset: 32)
        textField.height(60)
        
        view.addTapGesture {
            self.view.endEditing(true)
        }
    }
    
}

fileprivate struct PreviewUI: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> PreviewController {
        .init()
    }
    
    func updateUIViewController(_ uiViewController: PreviewController, context: Context) {
        
    }
    
}

#Preview {
    PreviewUI()
}

#endif
