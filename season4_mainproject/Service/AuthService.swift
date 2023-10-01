//
//  AuthService.swift
//  season4_mainproject
//
//  Created by Kang Hyeon Oh on 2023/10/01.
//

import Foundation

class AuthService {

    var urlPath = "\(HOST):\(PORT)/"

    func checkAccess(email: String, password: String) {
        let access_token : String = UserDefaults.standard.string(forKey: "access_token")!
        let refresh_token : String = UserDefaults.standard.string(forKey: "refresh_token")!
        let baseURL = urlPath + "auth"
        let url: URL = URL(string: urlPath)!
        var request = URLRequest(url: url)

        print("urlPath: \(urlPath)")

        // post방식 설정
        request.httpMethod = "POST"


        // HTTP 헤더 설정 (Content-Type을 JSON으로 설정)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(access_token)", forHTTPHeaderField: "Authorization")

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
            if httpResponse.statusCode == 401 {
                // 401 상태 코드인 경우 getAccess 함수 호출
                self.getAccess(refresh_token)
            }
        }

        // 요청을 실행합니다.
        task.resume()
    }
    
    func getAccess(_ refresh_token : String) {
        let baseURL = urlPath + "auth/access"
        let url: URL = URL(string: urlPath)!
        var request = URLRequest(url: url)

        print("urlPath: \(urlPath)")

        // post방식 설정
        request.httpMethod = "POST"


        // HTTP 헤더 설정 (Content-Type을 JSON으로 설정)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(refresh_token)", forHTTPHeaderField: "Authorization")

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
            if httpResponse.statusCode == 401 {

            }
        }

        // 요청을 실행합니다.
        task.resume()
    }

}
