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
    var moviedata: [MovieDetailModel]?
    
    //셀이 랜더링(그릴때) 될때
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateStarColor() {
        if let movie = moviedata, !movie.isEmpty {
            let starCount = movie[0].star
               let stars = [star1, star2, star3, star4, star5]
               for (index, starButton) in stars.enumerated() {
                   starButton?.tintColor = Int(starCount) > index ? UIColor.yellow : UIColor.gray
               }
        }
       }
    
    
    
    
}
