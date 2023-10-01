//
//  LoginVM.swift
//  season4_mainproject
//
//  Created by TJ on 2023/09/25.
//

import Foundation
import JWTDecode

let PORT = Bundle.main.object(forInfoDictionaryKey: "PORT") as? String ?? ""
let HOST = Bundle.main.object(forInfoDictionaryKey: "HOST") as? String ?? ""

protocol LoginProtocol {
    func loginCheck(item: tokenModel)
}

// MARK: Editted by Oh-Kang94
class LoginCheckModel {

    var delegate: LoginProtocol!
    var urlPath = "\(HOST):\(PORT)/auth"

    func downloadItems(email: String, password: String) {

        let url: URL = URL(string: urlPath)!
        var request = URLRequest(url: url)

        print("urlPath: \(urlPath)")

        // post방식 설정
        request.httpMethod = "POST"

        // body 데이터
        let requestData = [
            "email": email,
            "password": password
        ]

        do {
            // 요청 데이터를 JSON 형식으로 인코딩
            let jsonData = try JSONSerialization.data(withJSONObject: requestData)

            // HTTP 요청 본문에 데이터 설정
            request.httpBody = jsonData

            // HTTP 헤더 설정 (Content-Type을 JSON으로 설정)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        } catch {
            print("Error encoding JSON: \(error)")
            return
        }

        // URLSession으로 요청 보내기
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else {
                // 응답이 없는 경우
                return
            }

            if let error = error {
                print("Error: \(error)")
                return
            }

            let headers = httpResponse.allHeaderFields
            // headers에는 응답의 모든 헤더가 포함됩니다.

            // 예제: Content-Type 헤더 읽기
            if let access_token = headers["access_token"] as? String {
                UserDefaults.standard.setValue(access_token, forKey: "access_token")
            }

            if let refresh_token = headers["refresh_token"] as? String {
                UserDefaults.standard.setValue(refresh_token, forKey: "refresh_token")
            }

            // 서버로부터의 응답을 처리합니다.
            if let data = data {
                // 데이터를 사용하거나 파싱합니다.
                self.parseJSON(data)
            }
        }
        
        // 요청을 실행합니다.
        task.resume()
    }
    
    func parseJSON(_ data: Data){
        let decoder = JSONDecoder()
        var location = tokenModel(message: "", name: "", nickname: "")
        do{
            // JSON Array 형태이므로 배열에 맞게 인덱스별로 나누어 접근을 해야 한다.
            let result = try decoder.decode([AuthJSON].self, from: data) // json 풀기
            // 배열이므로 첫번째 값을 주어야한다.
            location = tokenModel(message: result[0].message, name: result[0].name, nickname: result[0].nickname)
        }catch{
            print("Fail: \(error.localizedDescription)")
            print(String(describing: error))
        }
        DispatchQueue.main.async {
            //print("MODELcount: \(count)")
            self.delegate.loginCheck(item: location) // delegate를 통해 프로토콜에 파싱한 데이터를 넘겨준다
        }
    }
}
