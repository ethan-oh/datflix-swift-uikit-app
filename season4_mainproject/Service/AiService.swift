//
//  AiService.swift
//  season4_mainproject
//
//  Created by Kang Hyeon Oh on 2023/09/26.
//

import Foundation

class AiService {
    var delegate: JSONMovieQueryModelProtocol!
    func calcScore(review: String, completion: @escaping (Double?) -> Void) {
        let baseUrl = HOST + ":" + PORT + "/ai/review"

        let url = URL(string: baseUrl)
        var request = URLRequest(url: url!)

        // POST 방식 설정
        request.httpMethod = "POST"
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

    func searchTop(title: String) {
        let baseUrl = HOST + ":" + PORT + "/ai/search"

        guard let url = URL(string: baseUrl) else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        var locations: [MovieModel] = []

        // POST 방식 설정
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters = ["title": title]

        do {
            let uploadData = try JSONSerialization.data(withJSONObject: parameters)

            // URLSession 객체를 통해 전송, 응답값 처리
            let task = URLSession.shared.uploadTask(with: request, from: uploadData) { (data, response, error) in
                // 서버가 응답이 없거나 통신이 실패
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }

                // 응답 데이터가 있는지 확인
                guard let data = data else {
                    print("No data received.")
                    return
                }

                do {
                    // JSON 디코딩
                    let decoder = JSONDecoder()
                    let movieData = try decoder.decode(MovieData.self, from: data)
                    // 필요한 작업을 수행하세요
                    for movie in movieData.result {
                        let query = MovieModel(id: movie.id, ott: movie.ott, title: movie.title, imagepath: movie.imagepath, releasedate: movie.releasedate, genre: movie.genre, totalaudience: movie.totalaudience, contry: movie.country, rating: movie.rating, star: Int(movie.star), runningtime: movie.runningtime, summary: movie.summary)
                        locations.append(query)
                    }
                } catch {
                    print("JSON decoding error: \(error.localizedDescription)")
                }
                DispatchQueue.main.async {
                    self.delegate.itemDownloaded(item: locations)
                }
            }

            // task 시작
            task.resume()
        } catch {
            print("JSON serialization error: \(error.localizedDescription)")
        }
    }

}

