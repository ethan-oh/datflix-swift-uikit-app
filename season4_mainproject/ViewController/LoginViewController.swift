//
//  LoginViewController.swift
//  season4_mainproject
//
//  Created by TJ on 2023/09/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    let myAlert = MyAlert()
    
    var data = tokenModel(message: "", name: "", nickname: "")
    
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
            UserDefaults.standard.setValue(tfEmail.text!.trimmingCharacters(in: .whitespaces), forKey: "email")
            UserDefaults.standard.setValue(data.name, forKey: "name")
            UserDefaults.standard.setValue(data.nickname, forKey: "nickname")
            
            // 유저탭바는 맨 첨으로 돌려놓고나서 이동
            // false 한 이유는 트루 해놓으면 밑의 알러트가 실행이 안 되더라
            navigationController?.popViewController(animated: false)
            
            // home tabbar로 이동
            myAlert.showMoveTabAlert(on: self, content: "로그인 성공.", index: 0)
        }
    }
}
