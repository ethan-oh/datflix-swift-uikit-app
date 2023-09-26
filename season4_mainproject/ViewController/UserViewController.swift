//
//  UserViewController.swift
//  season4_mainproject
//
//  Created by TJ on 2023/09/21.
//

import UIKit

class UserViewController: UIViewController {

    let myAlert = MyAlert()
    
    @IBOutlet weak var btnLogIn: UIButton! // 버는이름 변경하기 위해
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblNickName: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if User.access_token.isEmpty {
            btnLogIn.setTitle("로그인", for: .normal)
            resetLabelText()
        } else {
            btnLogIn.setTitle("로그아웃", for: .normal)
            setLabelText()
        }
    }
    
    
    @IBAction func btnLogInOut(_ sender: UIButton) {
        if User.access_token.isEmpty {
            self.performSegue(withIdentifier: "sgUserToLogin", sender: nil)
        } else {
            resetUserData()
            myAlert.showMoveTabAlert(on: self, content: "로그아웃 되었습니다.", index: 0)
        }
    }
    
    func resetUserData(){
        User.nickname = ""
        User.name = ""
        User.access_token = ""
        User.refresh_token = ""
    }
    
    func resetLabelText(){
        lblEmail.text = ""
        lblName.text = ""
        lblNickName.text = ""
    }
    
    func setLabelText(){
        lblEmail.text = User.email
        lblName.text = User.name
        lblNickName.text = User.nickname
    }

}
