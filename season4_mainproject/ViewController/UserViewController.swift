//
//  UserViewController.swift
//  season4_mainproject
//
//  Created by TJ on 2023/09/21.
//

import UIKit

class UserViewController: UIViewController {

    let myAlert = MyAlert()

    var newNickName = ""
    
    let changeUserVM = ChangeUserVM()
    
    
    @IBOutlet weak var btnLogIn: UIButton! // 버튼이름 변경하기 위해
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblNickName: UILabel!
    @IBOutlet weak var btnChangePW: UIButton!
    @IBOutlet weak var btnChangeNickname: UIButton!
    @IBOutlet weak var tfName: UILabel!
    @IBOutlet weak var tfNickName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        changeUserVM.delegate = self
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
        
        let pwAlert = UIAlertController(title: "비밀번호 변경", message: nil, preferredStyle: .alert)
        pwAlert.addTextField(){ textField in
            textField.placeholder = "현재 비밀번호를 입력해주세요."
            textField.isSecureTextEntry = true
        }
        pwAlert.addTextField(){ textField in
            textField.placeholder = "변경하실 비밀번호를 입력해주세요."
            textField.isSecureTextEntry = true
        }
        pwAlert.addTextField(){ textField in
            textField.placeholder = "비밀번호를 다시 한 번 입력해주세요."
            textField.isSecureTextEntry = true
        }

        let okAction = UIAlertAction(title: "확인", style: .default, handler: {ACTION in
            
            let currentPW = pwAlert.textFields?[0].text ?? ""
            let newPW = pwAlert.textFields?[1].text ?? ""
            
            // 세 개 입력창 중 하나라도 비어있을 경우
            if pwAlert.textFields?[0].text?.isEmpty == true || pwAlert.textFields?[1].text?.isEmpty == true || pwAlert.textFields?[2].text?.isEmpty == true{
                self.myAlert.showDefaultAlert(on: self, content: "모든 입력란을 채워주세요.")
            // 세 개 다 채워졌을 때
            }else {
                // 새 비밀번호 두 개가 일치할 경우
                if pwAlert.textFields?[1].text == pwAlert.textFields?[2].text{
                    // 기존과 동일한 비밀번호를 입력했을 경우
                    if pwAlert.textFields?[0].text == pwAlert.textFields?[1].text{
                        self.myAlert.showDefaultAlert(on: self, content: "현재 비밀번호와 동일합니다.")
                    }else{
                        // 변경 요청
                        self.changeUserVM.updatePasswordModel(currentPW: currentPW, newPW: newPW)
                    }
                // 새 비번 두개가 일치하지 않을 경우
                } else {
                    self.myAlert.showDefaultAlert(on: self, content: "새로운 비밀번호가 일치하지 않습니다.")
                }
            }
            
            
            
        })

        let cancelAction = UIAlertAction(title: "취소", style: .cancel)

        pwAlert.addAction(okAction)
        pwAlert.addAction(cancelAction)
        self.present(pwAlert, animated: true)
    }
    
    @IBAction func btnChangeNickname(_ sender: UIButton) {

        let nicknameAlert = UIAlertController(title: "닉네임 변경", message: nil, preferredStyle: .alert)
        nicknameAlert.addTextField(){ textField in
            textField.placeholder = "변경하실 닉네임을 입력해주세요."
        }

        // ok버튼 눌렀을 때
        let okAction = UIAlertAction(title: "확인", style: .default, handler: {ACTION in
    
            let newNickname = nicknameAlert.textFields?[0].text
            self.newNickName = nicknameAlert.textFields?[0].text ?? ""
            
            // 입력값이 비어있지 않을 때
            if newNickname?.isEmpty == false{
                self.changeUserVM.updateNickModel(nickname: nicknameAlert.textFields?[0].text ?? "")
            // 아무 값도 입력하지 않았을 때
            }else{
                self.myAlert.showDefaultAlert(on: self, content: "닉네임을 입력해주세요.")
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
            tfName.isHidden = true
            tfNickName.isHidden = true
        }else{
            btnChangePW.isHidden = false
            btnChangeNickname.isHidden = false
            tfName.isHidden = false
            tfNickName.isHidden = false
        }
    }

}
// /////////////////////////////////////////////////////////////////////
extension UserViewController: PasswordProtocol{
    func getNickNameResult(code: Int) {
        print("controller nickname code : \(code)")
        if code == 200{
            print("변경 성공")
            self.lblNickName.text = self.newNickName
            self.myAlert.showDefaultAlert(on: self, content: "닉네임이 \(self.newNickName)으로 변경되었습니다.")
        }else if code == 300{
            // 서버 오류
            print("서버 오류")
            self.myAlert.showDefaultAlert(on: self, content: "서버 오류로 변경에 실패했습니다.\n관리자에게 문의해주세요.")
        }else if code == 401{
            print("토큰 불일치")
            // refresh token으로 access token 재발급 후 다시 요청하기.
            return
        }else if code == 400{
            print("권한 없음")
            // 변경 권한이 없으므로 처리해주기
            return
        }else if code == 403{
            print("닉네임 중복됨")
            self.myAlert.showDefaultAlert(on: self, content: "이미 존재하는 닉네임입니다.")
        }
    }
    
    func getPwResult(code: Int) {
        if code == 200{ // 수정이 완료된 경우
            self.myAlert.showDefaultAlert(on: self, content: "비밀번호 변경 완료.")
        }else if code == 403{ // 현재 비밀번호가 틀렸을 경우
            self.myAlert.showDefaultAlert(on: self, content: "비밀번호가 일치하지 않습니다.")
        }else if code == 400{
            return
        }else if code == 401{
            self.myAlert.showDefaultAlert(on: self, content: "유저 권한 만료.")
        }else{
            return
        }
    }
    

}
