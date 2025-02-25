//
//  ViewController.swift
//  HW_103
//
//  Created by Азат Зиганшин on 24.09.2023.
//

import UIKit

class LoginViewController: UIViewController {
    
    lazy var MonaLisaImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "ReStore")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 10.0
        image.clipsToBounds = true
        return image
    }()
    
    lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Логин"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Пароль"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var loginTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Логин"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Пароль"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var joinButton: UIButton = {
        let button = UIButton()
        button.setTitle("Войти", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.buttonTapped()
        }), for: .touchUpInside)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupLayout()
        
        
    }
    
    @objc func buttonTapped() {
        if loginTextField.text == "Admin" && passwordTextField.text == "123" {
            let profileViewController = ProfileViewController()
            navigationController?.pushViewController(profileViewController, animated: true)
        }
    }
    
}
   
extension LoginViewController {
    
    func setupLayout() {

        let loginStackView = UIStackView(arrangedSubviews: [loginLabel, loginTextField])
        loginStackView.translatesAutoresizingMaskIntoConstraints = false
        loginStackView.axis = .vertical

        let passwordStackView = UIStackView(arrangedSubviews: [passwordLabel, passwordTextField])
        passwordStackView.translatesAutoresizingMaskIntoConstraints = false
        passwordStackView.axis = .vertical

        view.addSubview(MonaLisaImageView)
        view.addSubview(loginStackView)
        view.addSubview(passwordStackView)
        view.addSubview(joinButton)
        
        NSLayoutConstraint.activate([
            MonaLisaImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            MonaLisaImageView.heightAnchor.constraint(lessThanOrEqualToConstant: 300),
            MonaLisaImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            MonaLisaImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),

            loginStackView.topAnchor.constraint(equalTo: MonaLisaImageView.bottomAnchor, constant: 50),
            loginStackView.leadingAnchor.constraint(equalTo: MonaLisaImageView.leadingAnchor),
            loginTextField.trailingAnchor.constraint(equalTo: MonaLisaImageView.trailingAnchor),

            passwordStackView.topAnchor.constraint(equalTo: loginStackView.bottomAnchor, constant: 20),
            passwordStackView.leadingAnchor.constraint(equalTo: MonaLisaImageView.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: MonaLisaImageView.trailingAnchor),
            
            joinButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            joinButton.topAnchor.constraint(equalTo: passwordStackView.bottomAnchor, constant: 30)
        ])
    }
}
