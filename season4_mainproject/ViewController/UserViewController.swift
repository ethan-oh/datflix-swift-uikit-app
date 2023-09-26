//
//  UserViewController.swift
//  season4_mainproject
//
//  Created by TJ on 2023/09/21.
//

import UIKit

class UserViewController: UIViewController {

    @IBOutlet weak var btnLogIn: UIButton!
    
    let myAlert = MyAlert()
    
    @IBOutlet weak var lblEmail: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if User.access_token.isEmpty {
            btnLogIn.setTitle("로그인", for: .normal)
            lblEmail.text = ""
        } else {
            btnLogIn.setTitle("로그아웃", for: .normal)
            lblEmail.text = User.email
        }
    }
    
    
    @IBAction func btnLogInOut(_ sender: UIButton) {
        if User.access_token.isEmpty {
            self.performSegue(withIdentifier: "sgUserToLogin", sender: nil)
        } else {
            resetUserData()
            myAlert.showSegAlert(on: self, content: "로그아웃 되었습니다.", seg: "sgUserToHome")
        }
    }
    
    func resetUserData(){
        User.nickname = ""
        User.name = ""
        User.access_token = ""
        User.refresh_token = ""
    }

}
