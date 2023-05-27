//
//  SortViewController.swift
//  FileManager
//
//  Created by ln on 23.04.2023.
//

import UIKit
import KeychainAccess

class PasswordChangeViewController: UIViewController {
    
    var keychain = Keychain()
    
    private lazy var passwordTextField: UITextField = {
        var textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor.systemGray6
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 10
        textField.clipsToBounds = true
        textField.autocapitalizationType = .none
        textField.font = UIFont(name: "systemFont-Normal", size: 16)
        textField.placeholder = "  Введите пароль"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var createPasswordButton: UIButton = {
        var button = UIButton()
        button.backgroundColor = .blue
        button.setTitle("Сменить пароль", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(self.didTapCreateButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .systemMint
        setupView()
    }

    @objc private func didTapCreateButton() {
        
        let pass = passwordTextField.text
        if pass?.count ?? 0 > 3 {
            keychain["password"] = passwordTextField.text
            AlertErrorSample.shared.alert(title: "Успешно", message: "Пароль изменен")
        } else if passwordTextField.text?.count ?? 0 < 4 {
            AlertErrorSample.shared.alert(title: "Ошибка", message: "Пароль должен состоять из 4 или более символов")
        }
    }
    
    private func setupView() {
        self.view.addSubview(passwordTextField)
        self.view.addSubview(createPasswordButton)
        NSLayoutConstraint.activate([
        
            passwordTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            passwordTextField.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.06112469),
            
            createPasswordButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant:  16),
            createPasswordButton.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            createPasswordButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            createPasswordButton.heightAnchor.constraint(equalTo: passwordTextField.heightAnchor)
            ])
    }
    
}
