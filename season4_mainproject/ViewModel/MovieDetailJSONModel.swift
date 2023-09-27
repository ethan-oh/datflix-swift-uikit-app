//
//  MovieDetailJSONModel.swift
//  season4_mainproject
//
//  Created by 박지환 on 2023/09/26.
//

import Foundation

protocol MovieDetailQueryModelProtocol{
    func itemDownloaded(item: [MovieDetailModel])
}

class MovieDetailQueryModel{
    var delegate: MovieDetailQueryModelProtocol!
        
    func fetchDataFromAPI(seq:Int) {
            let PORT = Bundle.main.object(forInfoDictionaryKey: "PORT") as? String ?? ""
            let HOST = Bundle.main.object(forInfoDictionaryKey: "HOST") as? String ?? ""
            // API 엔드포인트 URL
            let apiUrl = "\(HOST):\(PORT)/movie/\(seq)"
            var locations: [MovieDetailModel] = []
            // task 변수를 클로저 외부에서 선언
            let task = URLSession.shared.dataTask(with: URL(string: apiUrl)!) { (data, response, error) in
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
                    let movieData = try decoder.decode(MovieDetail.self, from: data)
                    let movie = movieData.result
                    locations.append(movie)
                } catch {
                    print("JSON decoding error: \(error.localizedDescription)")
                }
                
                DispatchQueue.main.async {
                    self.delegate.itemDownloaded(item: locations)
                }
            }
            
            // task 시작
            task.resume()
        }
    }
