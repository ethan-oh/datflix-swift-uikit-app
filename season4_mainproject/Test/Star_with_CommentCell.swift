//
//  Star_with_CommentCell.swift
//  season4_mainproject
//
//  Created by 박지환 on 2023/09/25.
//

import Foundation
import UIKit

class Star_with_CommentCell: UITableViewCell {
    
    
    @IBOutlet weak var star1: UIButton!
    @IBOutlet weak var star2: UIButton!
    @IBOutlet weak var star3: UIButton!
    @IBOutlet weak var star4: UIButton!
    @IBOutlet weak var star5: UIButton!
    var starCount = 0
    //셀이 랜더링(그릴때) 될때
    override func awakeFromNib() {
        super.awakeFromNib()
        
        print("Star_with_CommentCell - awakeFromNib() called")
    }
    
    @IBAction func btnStar(_ sender: UIButton) {
        starCount = 1
        updateStarColor()
    }
    
    
    @IBAction func btnStar2(_ sender: UIButton) {
        starCount = 2
        updateStarColor()
    }
    
    
    @IBAction func btnStar3(_ sender: UIButton) {
        starCount = 3
        updateStarColor()
    }
    
    
    @IBAction func btnStar4(_ sender: UIButton) {
        starCount = 4
        updateStarColor()
    }
    
    
    @IBAction func btnStar5(_ sender: UIButton) {
        starCount = 5
        updateStarColor()
    }
    
    func updateStarColor() {
        // 모든 별 버튼을 초기 상태(회색)로 설정
        star1.tintColor = UIColor.gray
        star2.tintColor = UIColor.gray
        star3.tintColor = UIColor.gray
        star4.tintColor = UIColor.gray
        star5.tintColor = UIColor.gray
        
        // 선택된 별 버튼까지만 색상을 변경
        switch starCount {
        case 1:
            print("1번 별입니다")
            star1.tintColor = UIColor.yellow
        case 2:
            print("2번 별입니다")
            star1.tintColor = UIColor.yellow
            star2.tintColor = UIColor.yellow
        case 3:
            print("3번 별입니다")
            star1.tintColor = UIColor.yellow
            star2.tintColor = UIColor.yellow
            star3.tintColor = UIColor.yellow
        case 4:
            print("4번 별입니다")
            star1.tintColor = UIColor.yellow
            star2.tintColor = UIColor.yellow
            star3.tintColor = UIColor.yellow
            star4.tintColor = UIColor.yellow
        case 5:
            print("5번 별입니다")
            star1.tintColor = UIColor.yellow
            star2.tintColor = UIColor.yellow
            star3.tintColor = UIColor.yellow
            star4.tintColor = UIColor.yellow
            star5.tintColor = UIColor.yellow
        default:
            break
        }
    }
    
    
    
    
}
