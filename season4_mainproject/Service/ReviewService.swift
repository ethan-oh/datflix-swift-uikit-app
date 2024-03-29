//
//  ReviewService.swift
//  season4_mainproject
//
//  Created by Kang Hyeon Oh on 2023/09/25.
//

import Foundation

class ReviewService {
    ///  review insert
    func insertModel(movie_id: Int, content: String, rating : Double) -> Bool {
        let access_token : String = UserDefaults.standard.string(forKey: "access_token")!
        let baseUrl = HOST + ":" + PORT + "/review/"
        
        let url: URL = URL(string: baseUrl)!
        var request = URLRequest(url: url)
        
        print("urlPath: \(baseUrl)")
        
        // post방식 설정
        request.httpMethod = "POST"
        request.setValue("Bearer \(access_token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters = ReviewJson(movie_id: movie_id, content: content, rating: rating)
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
    func updateModel(movie_id: Int, content: String, rating : Double) -> Bool {
        let access_token : String = UserDefaults.standard.string(forKey: "access_token")!
        let baseUrl = HOST + ":" + PORT + "/review/" + String(movie_id)
        
        let url: URL = URL(string: baseUrl)!
        var request = URLRequest(url: url)
        
        print("urlPath: \(baseUrl)")
        
        // post방식 설정
        request.httpMethod = "PUT"
        request.setValue("Bearer \(access_token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters = ReviewJson(content: content, rating: rating)
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
    
    /// Review Read
    func readModel(movie_id: Int, completion: @escaping ([Review]) -> Void) {
        let baseUrl = HOST + ":" + PORT + "/review/" + String(movie_id)
        print(baseUrl)
        
        let url: URL = URL(string: baseUrl)!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Invalid HTTP response")
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }

            guard let data = data else {
                print("No data received")
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }

            let reviews = self.parseJSON(data)
            DispatchQueue.main.async {
                completion(reviews)
            }
        }

        task.resume()

    }
    
    func deleteModel(movie_id: Int) -> Bool {
        var result: Bool = false
        let access_token: String = UserDefaults.standard.string(forKey: "access_token")!
        let baseUrl = HOST + ":" + PORT + "/review/" + String(movie_id)
        
        let url: URL = URL(string: baseUrl)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(access_token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // 서버가 응답이 없거나 통신이 실패
            if let e = error {
                NSLog("An error has occurred: \(e.localizedDescription)")
                return
            }
            
            // 응답 처리 로직
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    print("Review deleted successfully")
                } else {
                    print("Failed to delete review. Status code: \(httpResponse.statusCode)")
                }
            }
        }
        
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
                let query = Review(nickname : review.nickname, movie_id : Int(review.movie_id!), content: review.content, rating: review.rating, insertdate: review.insertdate)
                locations.append(query)
            }
        } catch {
            print("Fail : \(error.localizedDescription)")
        }
        return locations
    }
}
