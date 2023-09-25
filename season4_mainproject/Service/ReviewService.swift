//
//  ReviewService.swift
//  season4_mainproject
//
//  Created by Kang Hyeon Oh on 2023/09/25.
//

import Foundation

class ReviewService {
    ///  review insert
    func insertModel(movie_id: Int, content: String, rating : Float) -> Bool {
        let access_token : String = User.access_token // 언제든지 바꿀 수 있는다.
        let baseUrl = HOST + PORT + "/review"
        
        let url: URL = URL(string: baseUrl)!
        var request = URLRequest(url: url)
        
        print("urlPath: \(baseUrl)")
        
        // post방식 설정
        request.httpMethod = "POST"
        request.setValue("Authorization", forHTTPHeaderField: "Bearer \(access_token)")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters = ReviewJson(movie_id: movie_id, content: content, ratring: rating)
        guard let uploadData = try? JSONEncoder().encode(parameters)
            else { return false }

        var result: Bool = false
        // URLSession 객체를 통해 전송, 응답값 처리
        let task = URLSession.shared.uploadTask(with: request, from: uploadData) { (data, response, error) in

            // 서버가 응답이 없거나 통신이 실패
            if let e = error {
                NSLog("An error has occured: \(e.localizedDescription)")
                return
            }
            // 응답 처리 로직
            print("comment post success")
        }
        // POST 전송
        task.resume()
        result = true
        return result
    }
    
    /// Review Update
    func updateModel(movie_id: Int, content: String, rating : Float) -> Bool {
        let access_token : String = User.access_token // 언제든지 바꿀 수 있는다.
        let baseUrl = HOST + PORT + "/review/" + String(movie_id)
        
        let url: URL = URL(string: baseUrl)!
        var request = URLRequest(url: url)
        
        print("urlPath: \(baseUrl)")
        
        // post방식 설정
        request.httpMethod = "PUT"
        request.setValue("Authorization", forHTTPHeaderField: "Bearer \(access_token)")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters = ReviewJson(content: content, ratring: rating)
        guard let uploadData = try? JSONEncoder().encode(parameters)
            else { return false }

        var result: Bool = false
        // URLSession 객체를 통해 전송, 응답값 처리
        let task = URLSession.shared.uploadTask(with: request, from: uploadData) { (data, response, error) in

            // 서버가 응답이 없거나 통신이 실패
            if let e = error {
                NSLog("An error has occured: \(e.localizedDescription)")
                return
            }
            // 응답 처리 로직
            print("comment post success")
        }
        // POST 전송
        task.resume()
        result = true
        return result
    }
    
    
    func parseJSON(_ data: Data) -> [Review] {
        let decoder = JSONDecoder()
        var locations: [Review] = []
        do {
            let reviewlists = try decoder.decode(ReviewJSONResults.self, from: data)
            for review in reviewlists.result {
                let query = Review(movie_id : review.movie_id!, content: review.content, ratring: review.ratring)
                locations.append(query)
            }
        } catch {
            print("Fail : \(error.localizedDescription)")
        }
        return locations
    }
}
