//
//  LoginViewController.swift
//  season4_mainproject
//
//  Created by TJ on 2023/09/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    let myAlert = MyAlert()
    
    var data = tokenModel(message: "", access_token: "", refresh_token: "", nickname: "", name: "")
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnRegister(_ sender: UIButton) {
    }
    
    @IBAction func btnLogin(_ sender: UIButton) {
        if tfEmail.text!.trimmingCharacters(in: .whitespaces).isEmpty{
            myAlert.showDefaultAlert(on: self, content: "Email을 입력해주세요.")
        } else if tfPassword.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            myAlert.showDefaultAlert(on: self, content: "Password를 입력해주세요.")
        } else {
            readValue()
        }
    }
    
    func readValue(){
        let email = tfEmail.text?.trimmingCharacters(in: .whitespaces)
        let password = tfPassword.text?.trimmingCharacters(in: .whitespaces)
        
        let loginCheckModel = LoginCheckModel()
        loginCheckModel.delegate = self
        loginCheckModel.downloadItems(email: email!, password: password!)

    }
    
}

extension LoginViewController: LoginProtocol{
    func loginCheck(item: tokenModel) {
        
        data = item
        
        if data.message != "Logged in successfully" {
            myAlert.showDefaultAlert(on: self, content: "아이디나 패스워드가 틀렸습니다.")
        } else {
            User.email = tfEmail.text!.trimmingCharacters(in: .whitespaces)
            User.access_token = data.access_token
            User.refresh_token = data.refresh_token
            User.name = data.name
            User.nickname = data.nickname
            
            myAlert.showPopAlert(on: self, content: "로그인 성공.")
        }
    }
}
