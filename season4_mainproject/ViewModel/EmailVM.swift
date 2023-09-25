//
//  EmailVM.swift
//  season4_mainproject
//
//  Created by TJ on 2023/09/25.
//

import Foundation

protocol EmailProtocol {
    func getEmailResult(code: Int)
}

class EmailDupCheckModel {
    var delegate: EmailProtocol!
    var urlPath = "\(HOST):\(PORT)/user/email/"
    
    func downloadItems(email: String) {
        let urlAdd = email
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
                    self.delegate.getEmailResult(code: -1) // 오류 시 -1 전달
                }
            }
        }
        
        task.resume()
    }
    
    func parseResponse(code: Int) {
        DispatchQueue.main.async {
            self.delegate.getEmailResult(code: code) // 상태 코드를 델리게이트를 통해 전달
        }
    }
}
