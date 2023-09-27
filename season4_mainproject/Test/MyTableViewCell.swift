//
//  MyTableViewCell.swift
//  season4_mainproject
//
//  Created by 박지환 on 2023/09/25.
//

import Foundation
import UIKit
import Cosmos

class MyTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var star1: UIButton!
    @IBOutlet weak var star2: UIButton!
    @IBOutlet weak var star3: UIButton!
    @IBOutlet weak var star4: UIButton!
    @IBOutlet weak var star5: UIButton!
    var starCount = 0
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var insertDate: UILabel!
    @IBOutlet weak var cosmosOh: CosmosView!
    
    
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userContentLabel: UILabel!
    //셀이 랜더링(그릴때) 될때
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userProfileImage.layer.cornerRadius = userProfileImage.frame.width / 2
    }
    func cosmosviewActivate(percentage: String){
        let cosmosView = CosmosView()
        cosmosView.settings.fillMode = .precise
        cosmosView.settings.updateOnTouch = false
        cosmosView.rating = Double(percentage)! / 20.0
    }
    
    
    
    
    
}
