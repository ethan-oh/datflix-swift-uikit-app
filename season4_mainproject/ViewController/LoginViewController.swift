//
//  LoginViewController.swift
//  season4_mainproject
//
//  Created by TJ on 2023/09/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    var data = tokenModel(message: "", access_token: "", refresh_token: "")
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    @IBAction func btnRegister(_ sender: UIButton) {
    }
    
    @IBAction func btnLogin(_ sender: UIButton) {
        if tfEmail.text!.trimmingCharacters(in: .whitespaces).isEmpty{
            let resultAlert = UIAlertController(title: "결과", message: "Email을 입력해주세요.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "네", style: .default)
            
            resultAlert.addAction(okAction)
            present(resultAlert, animated: true)
        }else if tfPassword.text!.trimmingCharacters(in: .whitespaces).isEmpty{
            let resultAlert = UIAlertController(title: "결과", message: "Password를 입력해주세요.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "네", style: .default)
            
            resultAlert.addAction(okAction)
            present(resultAlert, animated: true)
        }else{
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    

}

extension LoginViewController: LoginProtocol{
    
    func loginCheck(item: tokenModel) {
        data = item
        if data.message != "Logged in successfully" {
            let resultAlert = UIAlertController(title: "결과", message: "아이디나 패스워드를 확인해주세요.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "네", style: .default)
            
            resultAlert.addAction(okAction)
            present(resultAlert, animated: true)
        }else{
            User.email = tfEmail.text!.trimmingCharacters(in: .whitespaces)
            
            let resultAlert = UIAlertController(title: "결과", message: "로그인 성공.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "네", style: .default, handler: {ACTION in
                self.performSegue(withIdentifier: "sgLogin", sender: nil)
            })
            
            resultAlert.addAction(okAction)
            present(resultAlert, animated: true)
        }
    }
}
