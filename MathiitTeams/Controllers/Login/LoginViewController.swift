//
//  LoginViewController.swift
//  W
//
//  Created by Mac on 20/02/21.
//  Copyright © 2021 Mac. All rights reserved.
//

import UIKit
import FirebaseAuth
class LoginViewController: UIViewController {
    
    private let ScrollView: UIScrollView = {
       let scrollView = UIScrollView()
       scrollView.clipsToBounds = true 
       return scrollView
    }()
    
    
    private let emailField: UITextField = {
       let field = UITextField()
       field.autocapitalizationType = .none
       field.autocorrectionType = .no
       field.returnKeyType = .continue
       field.layer.cornerRadius = 12
       field.layer.borderWidth = 1
       field.layer.borderColor = UIColor.gray.cgColor
       field.placeholder = "Email Address..."
        
       field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
       field.leftViewMode = .always
       field.backgroundColor = .white
       return field
    }()
    
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.gray.cgColor
        field.placeholder = "Password..."
        
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.isSecureTextEntry = true
        return field
    }()
    
    
    private let loginButton: UIButton = {
       let button = UIButton()
       button.setTitle("Log In", for: .normal)
       button.backgroundColor = .orange
        
       button.setTitleColor(.white, for: .normal)
       button.layer.cornerRadius = 12
       button.layer.masksToBounds = true
       button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
       return button
    }()
    
    private let imageView: UIImageView = {
       let imageView = UIImageView()
       imageView.image = UIImage(named: "Logo")
       imageView.contentMode = .scaleAspectFit
       return imageView
    }()
    
    
    @objc private func loginButtonTapped() {
        
        
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let email = emailField.text, let password = passwordField.text,
            !email.isEmpty , !password.isEmpty , password.count >= 6 else {
                alertUserLoginError()
                return
    }
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: {[weak self  ]authResult , error in
            guard let strongSelf = self else {
                return
            }
            guard let result = authResult , error == nil else {
                print("Error log in with \(email)")
                return
            }
            
            let user = result.user
            print("Logged in \(user)")
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        })
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Log in"
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didTapRegister))
       
        loginButton.addTarget(self,
                              action: #selector(LoginViewController.loginButtonTapped),
                              for: .touchUpInside)
        
        
        emailField.delegate = self
        passwordField.delegate = self
        
        //add subviews
        view.addSubview(ScrollView)
        ScrollView.addSubview(imageView)
        ScrollView.addSubview(emailField)
        ScrollView.addSubview(passwordField)
        ScrollView.addSubview(loginButton)
        
        
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        ScrollView.frame = view.bounds
        let size = ScrollView.width/3
        imageView.frame = CGRect(x: (ScrollView.width-size)/2,
                                 y: 20,
                                 width: size,
                                 height: size)
        emailField.frame = CGRect(x: 30,
                                  y: imageView.bottam+10,
                                  width: ScrollView.width-60,
                                  height: 52)
        passwordField.frame = CGRect(x: 30,
                                  y: emailField.bottam+10,
                                  width: ScrollView.width-60,
                                  height: 52)
        loginButton.frame = CGRect(x: 30,
                                     y: passwordField.bottam+10,
                                     width: ScrollView.width-60,
                                     height: 52)
    }

    
    
    //Firebase Log in
    
    func alertUserLoginError() {
        let alert = UIAlertController(title: "Woops", message: "Please enter all information to log in ", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert , animated: true)
        
    }
    
    
    
    @objc private func didTapRegister() {
        let vc = RegisterViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }
    

   
}


extension LoginViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        
        else if textField == passwordField {
            loginButtonTapped()
        }
        return true
    }
}
