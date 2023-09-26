//
//  AiService.swift
//  season4_mainproject
//
//  Created by Kang Hyeon Oh on 2023/09/26.
//

import Foundation

class AiService {
    func calcScore(review: String, completion: @escaping (Double?) -> Void) {
        let access_token: String = User.access_token // 언제든지 바꿀 수 있는다.
        let baseUrl = HOST + ":" + PORT + "/ai/review"
        
        let url = URL(string: baseUrl)
        var request = URLRequest(url: url!)
        
        // POST 방식 설정
        request.httpMethod = "POST"
        request.setValue("Bearer \(access_token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters = ["review": review]
        
        guard let uploadData = try? JSONSerialization.data(withJSONObject: parameters) else {
            completion(nil)
            return
        }
        
        var result: Double?
        
        // URLSession 객체를 통해 전송, 응답값 처리
        let task = URLSession.shared.uploadTask(with: request, from: uploadData) { (data, response, error) in
            // 서버가 응답이 없거나 통신이 실패
            if let e = error {
                NSLog("An error has occurred: \(e.localizedDescription)")
                completion(nil)
                return
            }
            
            // 응답 처리 로직
            if let responseData = data,
               let jsonResponse = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any],
               let results = jsonResponse["results"] as? String {
                result = Double(results)
            }
            
            completion(result)
        }
        
        // POST 전송
        task.resume()
    }
}

