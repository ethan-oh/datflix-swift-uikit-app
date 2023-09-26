//
//  MovieCastCell.swift
//  ScrollView
//
//  Created by 박지환 on 2023/09/25.
//

import Foundation
import UIKit

class MovieCastCell: UITableViewCell {
    
    var movie: [MovieDetailModel]?
    @IBOutlet weak var imgCast: UIImageView!
    @IBOutlet weak var lblCastName: UILabel!
    @IBOutlet weak var lblCastRole: UILabel!
    
    
    var stateNumber = 0
    var isFullTextVisible = false
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
