//
//  MovieTableViewCell.swift
//  season4_mainproject
//
//  Created by TJ on 2023/09/26.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var movieImgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblGenre: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
