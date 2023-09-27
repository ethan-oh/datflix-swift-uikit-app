//
//  UserViewController.swift
//  season4_mainproject
//
//  Created by TJ on 2023/09/21.
//

import UIKit

class UserViewController: UIViewController {

    let myAlert = MyAlert()
    var codeValue = 0
    
    @IBOutlet weak var btnLogIn: UIButton! // 버튼이름 변경하기 위해
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblNickName: UILabel!
    @IBOutlet weak var btnChangePW: UIButton!
    @IBOutlet weak var btnChangeNickname: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 로그인 안 된 상태
        if UserDefaults.standard.string(forKey: "name") == nil {
            btnLogIn.setTitle("로그인", for: .normal)
            resetLabelText()
            changeButtonHidden(true) // 수정버튼 숨기기
        } else { // 로그인 된 상태
            btnLogIn.setTitle("로그아웃", for: .normal)
            setLabelText()
            changeButtonHidden(false) // 수정버튼 보이기
        }
    }
    
    @IBAction func btnChangePassword(_ sender: UIButton) {
        let pwAlert = UIAlertController(title: "닉네임 변경", message: nil, preferredStyle: .alert)
        pwAlert.addTextField(){ textField in
            textField.placeholder = "닉네임 입력"
        }

        let okAction = UIAlertAction(title: "확인", style: .default, handler: {ACTION in
    
            
        })

        let cancelAction = UIAlertAction(title: "취소", style: .cancel)

        pwAlert.addAction(okAction)
        pwAlert.addAction(cancelAction)
        self.present(pwAlert, animated: true)
    }
    
    @IBAction func btnChangeNickname(_ sender: UIButton) {
        
        let nicknameCheck = NicknameDupCheckModel()
        nicknameCheck.delegate = self
        
        let changeNickVM = ChangeNickVM()
        
        let nicknameAlert = UIAlertController(title: "닉네임 변경", message: nil, preferredStyle: .alert)
        nicknameAlert.addTextField(){ textField in
            textField.placeholder = "변경하실 닉네임을 입력해주세요."
        }

        let okAction = UIAlertAction(title: "확인", style: .default, handler: {ACTION in
    
            let newNickname = nicknameAlert.textFields?[0].text
            print("바꿀닉네임은 !!! \(nicknameAlert.textFields?[0].text ?? "")")
            if newNickname?.isEmpty == false{
                DispatchQueue.global(qos: .background).async {
                    nicknameCheck.downloadItems(nickname: newNickname!)
                    Thread.sleep(forTimeInterval: 0.1)
                    DispatchQueue.main.async {
                        print("code: \(self.codeValue)")
                        if self.codeValue == 200 {
                            let code = changeNickVM.updateModel(nickname: nicknameAlert.textFields?[0].text ?? "")
                            if code == 200{
                                self.lblNickName.text = nicknameAlert.textFields?[0].text
                                self.myAlert.showDefaultAlert(on: self, content: "닉네임이 \(nicknameAlert.textFields?[0].text ?? "")으로 변경되었습니다.")
                            }
                        }else{
                            self.myAlert.showDefaultAlert(on: self, content: "이미 존재하는 닉네임입니다.")
                        }
                    }
                }
                
            }else{
                return
            }
        })

        let cancelAction = UIAlertAction(title: "취소", style: .cancel)

        nicknameAlert.addAction(okAction)
        nicknameAlert.addAction(cancelAction)
        self.present(nicknameAlert, animated: true)
    }
    
    
    
    @IBAction func btnLogInOut(_ sender: UIButton) {
        if UserDefaults.standard.string(forKey: "name") == nil {
            self.performSegue(withIdentifier: "sgUserToLogin", sender: nil)
        } else {
            resetUserData()
            myAlert.showMoveTabAlert(on: self, content: "로그아웃 되었습니다.", index: 0)
        }
    }
    
    func resetUserData(){
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "access_token")
        UserDefaults.standard.removeObject(forKey: "refresh_token")
        UserDefaults.standard.removeObject(forKey: "name")
        UserDefaults.standard.removeObject(forKey: "nickname")
        
//        User.nickname = ""
//        User.name = ""
//        User.access_token = ""
//        User.refresh_token = ""
    }
    
    func resetLabelText(){
        lblEmail.text = ""
        lblName.text = ""
        lblNickName.text = ""
    }
    
    func setLabelText(){
        lblEmail.text = UserDefaults.standard.string(forKey: "email")
        lblName.text = UserDefaults.standard.string(forKey: "name")
        lblNickName.text = UserDefaults.standard.string(forKey: "nickname")
    }
    
    func changeButtonHidden(_ isHidden: Bool){
        if isHidden == true{
            btnChangePW.isHidden = true
            btnChangeNickname.isHidden = true
        }else{
            btnChangePW.isHidden = false
            btnChangeNickname.isHidden = false
        }
    }

}

extension UserViewController: NicknameProtocol{
    func getNicknameResult(code: Int) {
        codeValue = code
    }
}
