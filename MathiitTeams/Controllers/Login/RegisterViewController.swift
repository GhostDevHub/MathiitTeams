//
//  RegisterViewController.swift
//  W
//
//  Created by Mac on 20/02/21.
//  Copyright © 2021 Mac. All rights reserved.
//

import UIKit
import FirebaseAuth



class RegisterViewController: UIViewController {
    
    private let ScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    
    private let firstNameField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.gray.cgColor
        field.placeholder = "First Name..."
        
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    
    private let lastNameField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.gray.cgColor
        field.placeholder = "Last Name..."
        
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
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
    
    
    
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register ", for: .normal)
        button.backgroundColor = .orange
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.lightGray.cgColor 
        return imageView
    }()
    
    
    @objc private func registerButtonTapped() {
        
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        firstNameField.resignFirstResponder()
        
        guard let firstName = firstNameField.text,
        let lastName = lastNameField.text,
        let email = emailField.text, let password = passwordField.text,
            !email.isEmpty , !password.isEmpty , !firstName.isEmpty , !lastName.isEmpty , password.count >= 6 else {
                alertUserLoginError()
                return
        }
        
    //Firebase Log in
        
        DatabaseManager.shared.UserExists(with: email, compilication: { [weak self] exists in
            guard let strongSelf = self else {
                return
            }
            
            guard !exists else {
                strongSelf.alertUserLoginError(message: "Looks like a user account for that email address alderdy exists")
                return
            }
            
            
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: {authResult ,error in
                
                guard  authResult != nil , error == nil else {
                    print("Error creating account")
                    return
                }
                
                
                DatabaseManager.shared.insertUser(with: ChatAppUser(firstName:firstName , lastName:lastName , emailAddress:email))
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
                
            })
        })
        
        
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Log in"
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didTapRegister))
        
        registerButton.addTarget(self,
                              action: #selector(RegisterViewController.registerButtonTapped),
                              for: .touchUpInside)
        
        
        emailField.delegate = self
        passwordField.delegate = self
        
        //add subviews
        view.addSubview(ScrollView)
        ScrollView.addSubview(imageView)
        ScrollView.addSubview(emailField)
        ScrollView.addSubview(passwordField)
        ScrollView.addSubview(registerButton)
        ScrollView.addSubview(firstNameField)
        ScrollView.addSubview(lastNameField)
        imageView.isUserInteractionEnabled = true
        ScrollView.isUserInteractionEnabled = true 
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfile))
        
        imageView.addGestureRecognizer(gesture)
        
        
        }
    
    @objc private func didTapChangeProfile() {
        presentPhotoActionSheet()
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        ScrollView.frame = view.bounds
        let size = ScrollView.width/3
        imageView.frame = CGRect(x: (ScrollView.width-size)/2,
                                 y: 20,
                                 width: size,
                                 height: size)
        imageView.layer.cornerRadius = imageView.width/2.0
        
        
        firstNameField.frame = CGRect(x: 30,
                                  y: imageView.bottam+10,
                                  width: ScrollView.width-60,
                                  height: 52)
        
        lastNameField .frame = CGRect(x: 30,
                                  y: firstNameField.bottam+10,
                                  width: ScrollView.width-60,
                                  height: 52)
        
        emailField.frame = CGRect(x: 30,
                                  y: lastNameField.bottam+10,
                                  width: ScrollView.width-60,
                                  height: 52)
        passwordField.frame = CGRect(x: 30,
                                     y: emailField.bottam+10,
                                     width: ScrollView.width-60,
                                     height: 52)
        registerButton.frame = CGRect(x: 30,
                                   y: passwordField.bottam+10,
                                   width: ScrollView.width-60,
                                   height: 52)
    }
    
    
    
    
    func alertUserLoginError(message:String = "Please enter all information to create a new account ") {
        let alert = UIAlertController(title: "Woops", message: message , preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert , animated: true)
        
    }
    
    
    
    @objc private func didTapRegister() {
        let vc = RegisterViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}


extension RegisterViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
            
        else if textField == passwordField {
            registerButtonTapped()
        }
        return true
    }
}


extension RegisterViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Picture"
            , message: "How would you like to select a picture",
              preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take photo",
                                            style: .default,
                                            handler: { [weak self] _ in
                                                
                                                self?.presentCamera()
                                                
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose",
                                            style: .default ,
                                            handler: { [weak self] _ in
                                                self?.presentPhotoPicker()
                                                
        }))
        
        present(actionSheet , animated: true)
    }
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc , animated: true)
    }
    
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc , animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        print(info)
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage   else {
            return
        }
        self.imageView.image = selectedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
 
