//
//  RegisterViewController.swift
//  season4_mainproject
//
//  Created by TJ on 2023/09/21.
//

import UIKit

class RegisterViewController: UIViewController {

    // email 정규식
    let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    // Alert
    let myAlert = MyAlert()
    
    var data = ""
    var codeValue = 0
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfNickName: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfPwCheck: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.backgroundColor = UIColor.black
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnEmailCheck(_ sender: UIButton) {
        let email = tfEmail.text?.trimmingCharacters(in: .whitespaces)
        let emailDupCheckModel = EmailDupCheckModel()
        emailDupCheckModel.delegate = self
        if email!.isEmpty{
            myAlert.showDefaultAlert(on: self, content: "Email을 입력해주세요.")
        }else{
            emailDupCheckModel.downloadItems(email: email!)
        }
        
    }
    
    @IBAction func btnNicknameCheck(_ sender: UIButton) {
        let nickname = tfNickName.text?.trimmingCharacters(in: .whitespaces)
        let nicknameDupCheckModel = NicknameDupCheckModel()
        nicknameDupCheckModel.delegate = self
        if nickname!.isEmpty{
            myAlert.showDefaultAlert(on: self, content: "닉네임을 입력해주세요.")
        }else{
            nicknameDupCheckModel.downloadItems(nickname: nickname!)
        }

    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnRegister(_ sender: UIButton) {
        let email = tfEmail.text?.trimmingCharacters(in: .whitespaces)
        let name = tfName.text?.trimmingCharacters(in: .whitespaces)
        let nickname = tfNickName.text?.trimmingCharacters(in: .whitespaces)
        let password = tfPassword.text?.trimmingCharacters(in: .whitespaces)
        let pwCheck = tfPwCheck.text?.trimmingCharacters(in: .whitespaces)
        
        let registerModel = RegisterModel()
        registerModel.delegate = self
        
        
        if email!.isEmpty{
            myAlert.showDefaultAlert(on: self, content: "Email을 입력해주세요.")
        }else if name!.isEmpty{
            myAlert.showDefaultAlert(on: self, content: "이름을 입력해주세요.")
        }else if nickname!.isEmpty{
            myAlert.showDefaultAlert(on: self, content: "닉네임을 입력해주세요.")
        }else if password!.isEmpty{
            myAlert.showDefaultAlert(on: self, content: "비밀번호를 입력해주세요.")
        }else if password! != pwCheck!{
            myAlert.showDefaultAlert(on: self, content: "비밀번호가 일치하지 않습니다.")
        }else{
            registerModel.downloadItems(email: email!, password: password!, name: name!, nickname: nickname!)
            
        }
    }
}

extension RegisterViewController: RegisterProtocol, EmailProtocol, NicknameProtocol{
    func getEmailResult(code: Int) {
        codeValue = code
        if codeValue == 200{
            myAlert.showDefaultAlert(on: self, content: "사용 가능한 이메일입니다.")
        }else{
            myAlert.showDefaultAlert(on: self, content: "이미 사용중인 이메일입니다.")
        }
    }
    
    func getNicknameResult(code: Int) {
        codeValue = code
        if codeValue == 200{
            myAlert.showDefaultAlert(on: self, content: "사용 가능한 닉네임입니다.")
        }else{
            myAlert.showDefaultAlert(on: self, content: "이미 사용중인 닉네임입니다.")
        }
    }
    
    func register(item: String) {
        data = item
        let name = tfName.text!.trimmingCharacters(in: .whitespaces)
        if data == "User already exists" {
            myAlert.showDefaultAlert(on: self, content: "회원가입에 실패했습니다.")
        }else{
            myAlert.showPopAlert(on: self, content: "환영합니다 \(name)님")
        }
    }
}

