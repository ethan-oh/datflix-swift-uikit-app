//
//  NickNameVM.swift
//  season4_mainproject
//
//  Created by TJ on 2023/09/25.
//

import Foundation

protocol NicknameProtocol {
    func getNicknameResult(code: Int)
}

class NicknameDupCheckModel {
    var delegate: NicknameProtocol!
    var urlPath = "\(HOST):\(PORT)/user/nickname/"
    
    func downloadItems(nickname: String) {
        let urlAdd = nickname
        urlPath = urlPath + urlAdd
        
        // 한글 URL 인코딩
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        let url: URL = URL(string: urlPath)!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                let responseCode = httpResponse.statusCode
                DispatchQueue.main.async {
                    self.parseResponse(code: responseCode)
                }
            } else {
                DispatchQueue.main.async {
                    self.delegate.getNicknameResult(code: -1) // 오류 시 -1 전달
                }
            }
        }
        
        task.resume()
    }
    
    func parseResponse(code: Int) {
        DispatchQueue.main.async {
            self.delegate.getNicknameResult(code: code) // 상태 코드를 델리게이트를 통해 전달
        }
    }
}



