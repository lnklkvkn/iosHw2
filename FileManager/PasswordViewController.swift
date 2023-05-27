//
//  PasswordViewController.swift
//  FileManager
//
//  Created by ln on 19.04.2023.
//

import UIKit
import KeychainAccess


class PasswordViewController: UIViewController {
    
    var keychain = Keychain()
    
    var appState = false {
        didSet {
            if appState {
                loginButton.setTitle("Введите пароль", for:  .normal)
            } else {
                loginButton.setTitle("Создать пароль", for: .normal)
            }
        }
    }
    
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
    
    private lazy var loginButton: UIButton = {
        var button = UIButton()
        button.backgroundColor = .blue
        button.setTitle("Создать пароль", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(self.didTapLoginButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .orange
        setupView()
        
        if keychain["password"]?.count ?? 0 > 3 {
            appState = true
        }
    }

    @objc private func didTapLoginButton() {
        let pass = passwordTextField.text
        if pass?.count ?? 0 > 3 {
            if appState == false {
                keychain["password"] = passwordTextField.text
                appState = true
                loginButton.setTitle("Введите пароль", for: .normal)
                AlertErrorSample.shared.alert(title: "Успешно", message: "Пароль создан")
            } else if appState && pass == keychain["password"] {
                
                let filesVC = UINavigationController(rootViewController: FilesViewController())
                let settVC = SettingsViewController()
                let tabBarController = UITabBarController()
                tabBarController.viewControllers = [ filesVC , settVC]
                tabBarController.viewControllers?[0].navigationController?.isNavigationBarHidden = true
                self.navigationController?.isNavigationBarHidden = true
                
                tabBarController.viewControllers?.enumerated().forEach {
                    $1.tabBarItem.title = $0 == 0 ? "Files" : "Settings"
                    $1.tabBarItem.image = $0 == 0 ? UIImage(systemName: "list.bullet.clipboard") : UIImage(systemName: "gearshape.fill")
                }
                tabBarController.modalPresentationStyle = .automatic
                self.navigationController?.pushViewController(tabBarController, animated: true)
            } else if appState && pass != keychain["password"] {
                keychain["password"] = ""
                appState = false
                AlertErrorSample.shared.alert(title: "Неверный пароль", message: "Пароль сброшен")
            }
            
        } else if passwordTextField.text?.count ?? 0 < 4 {
            AlertErrorSample.shared.alert(title: "Ошибка", message: "Пароль должен состоять из 4 или более символов")
        } else {
            AlertErrorSample.shared.alert(title: "Ошибка", message: "Неверный пароль")
        }
    }
    
    private func setupView() {
        self.view.addSubview(passwordTextField)
        self.view.addSubview(loginButton)
        NSLayoutConstraint.activate([
        
            passwordTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            passwordTextField.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.06112469),
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant:  16),
            loginButton.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            loginButton.heightAnchor.constraint(equalTo: passwordTextField.heightAnchor)

            ])
    }
}
    
