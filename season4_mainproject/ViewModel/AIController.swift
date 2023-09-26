//
//  AIController.swift
//  season4_mainproject
//
//  Created by Kang Hyeon Oh on 2023/09/26.
//

import Foundation

class AIController {
    var service: AiService

    init(service: AiService) {
        self.service = service
    }

    func aiResultMessage(review: String, completion: @escaping (String) -> Void) {
        service.calcScore(review: review) { result in
            if let result = result {
                let percentage = String(result * 100)
                let message: String
                if result > 0.5 {
                    message = "\(percentage)% 확률로 긍정 리뷰입니다."
                } else {
                    message = "\(percentage)% 확률로 부정 리뷰입니다."
                }
                completion(message)
            } else {
                completion("분석 결과를 가져올 수 없습니다.") // 예외 처리: result가 nil인 경우
            }
        }
    }


}
