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
        setStyle()
    }
    
    @IBAction func btnRegister(_ sender: UIButton) {
    }
    
    @IBAction func btnLogin(_ sender: UIButton) {
        
        readValue()
        
    }
    
    func setStyle(){
        self.view.layer.backgroundColor = UIColor(red: 0.141, green: 0.165, blue: 0.196, alpha: 1).cgColor
          
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
            print(data.access_token)
            
            let resultAlert = UIAlertController(title: "결과", message: "로그인 성공.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "네", style: .default, handler: {ACTION in
                self.performSegue(withIdentifier: "sgLogin", sender: nil)
            })
            
            resultAlert.addAction(okAction)
            present(resultAlert, animated: true)
        }
    }
}
